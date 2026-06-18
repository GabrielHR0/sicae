class Escola < ApplicationRecord
  self.table_name = "public.escolas"

  belongs_to :rede, optional: true
  has_many :users, dependent: :nullify

  validates :nome, :schema_name, :slug, presence: true
  validates :slug, :schema_name, uniqueness: true

  after_create :create_schema, :create_base_tabela_preco

  private

  def create_base_tabela_preco
    connection_schema
    TabelaPreco.create!(
      descricao: "Preço base do produto, utilizado como principal referência",
      nome: "Tabela Base",
      tipo: 0,
      status: 1
      )
    connection_schema('public')
  end

  def create_schema(schema_name)
    begin
      TenantSchemaManager.create_schema!(schema_name)
    rescue => e
      update!(metadata: metadata.merge("schema_status" => "error", "schema_error" => e.message))
    raise
    end
  end

  def connection_schema(schema = schema_name)
    ActiveRecord::Base.connection.execute("SET search_path TO #{schema}")
  end
end
