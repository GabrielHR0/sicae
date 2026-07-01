class TenantSchemaManager
  class SchemaCreationError < StandardError; end

  def self.create_schema!(schema_name)
    new(schema_name).create_schema!
  end

  def initialize(schema_name)
    @schema_name = schema_name.to_s.strip
  end

  def create_schema!
    validate_schema_name!

    connection = ActiveRecord::Base.connection
    quoted_schema = connection.quote_table_name(@schema_name)

    connection.execute("CREATE SCHEMA IF NOT EXISTS #{quoted_schema}")

    load_tenant_structure!
    run_pending_migrations!
  rescue StandardError => e
    raise SchemaCreationError, "Falha ao criar schema #{@schema_name}: #{e.message}"
  end

  private

  def validate_schema_name!
    unless @schema_name.match?(/\A[a-z][a-z0-9_]*\z/)
      raise ArgumentError, "schema_name inválido: #{@schema_name}"
    end
  end

  def load_tenant_structure!
    connection = ActiveRecord::Base.connection
    previous_search_path = connection.schema_search_path
    connection.schema_search_path = @schema_name

    tabelas_globais = %w[escolas redes users roles permissions perfis responsaveis estudantes ar_internal_metadata schema_migrations users_roles roles_permissions]

    ActiveRecord::Migration.suppress_messages do
      schema_content = File.read(Rails.root.join("db", "schema.rb"))

      tabelas_globais.each do |tabela|
        schema_content.gsub!(/create_table "#{tabela}".*?end/m, "")
        schema_content.gsub!(/^  add_foreign_key "#{tabela}".*$/, "")
        schema_content.gsub!(/^  add_foreign_key .*, "#{tabela}"$/, "")
      end

      eval(schema_content)
    end
  ensure
    connection.schema_search_path = previous_search_path
  end

  def run_pending_migrations!
    connection = ActiveRecord::Base.connection
    previous_search_path = connection.schema_search_path
    connection.schema_search_path = @schema_name

    ActiveRecord::MigrationContext.new(
      ActiveRecord::Tasks::DatabaseTasks.migrations_paths
    ).migrate
  ensure
    connection.schema_search_path = previous_search_path
  end
end
