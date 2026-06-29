class Escola < ApplicationRecord
  self.table_name = "public.escolas"

  belongs_to :rede, optional: true
  has_many :users, dependent: :nullify

  validates :nome, :slug, :schema_name, presence: true
  validates :slug, :schema_name, uniqueness: true

  after_create :create_schema, :create_base_tabela_preco, :create_formas_pagamento
  before_validation :generate_identifiers, on: :create

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

  def generate_identifiers
    return if nome.blank?

    identifier = parametize_nome

    self.slug ||= identifier
    self.schema_name ||= ("tenant-"+identifier).tr("-", "_")
  end

  def parametize_nome
    nome.parameterize + SecureRandom.hex(2)
  end

  def create_schema
    begin
      TenantSchemaManager.create_schema!(schema_name)
    rescue => e
      update!(metadata: (metadata || {}).merge("schema_status" => "error", "schema_error" => e.message))
    raise
    end
  end

  def create_formas_pagamento
    connection_schema
    FormaPagamento.create!(nome: "Dinheiro", tipo: 0, aceita_troco: true, ativo: true)
    FormaPagamento.create!(nome: "Fatura", tipo: 1, aceita_troco: false, ativo: true)
    connection_schema("public")
  end

  def connection_schema(schema = schema_name)
    ActiveRecord::Base.connection.execute("SET search_path TO #{schema}")
  end
end
