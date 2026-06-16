namespace :db do
  namespace :migrate do
    desc "Run pending migrations in all tenant schemas"
    task tenants: :environment do
      ActiveRecord::Base.connection_pool.with_connection do |conn|
        schemas = conn.exec_query(<<~SQL).rows.flatten
          SELECT schema_name FROM information_schema.schemata
          WHERE schema_name NOT IN ('public', 'information_schema')
            AND schema_name NOT LIKE 'pg_%'
            AND schema_name !~ '^\d'
        SQL

        schemas.each do |schema|
          puts "-> Migrating #{schema}"
          conn.schema_search_path = schema
          ActiveRecord::MigrationContext.new(
            ActiveRecord::Tasks::DatabaseTasks.migrations_paths,
            ActiveRecord::SchemaMigration
          ).migrate
        end
      end
    end
  end
end