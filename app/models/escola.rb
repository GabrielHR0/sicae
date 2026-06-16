class Escola < ApplicationRecord
  self.table_name = "public.escolas"

  belongs_to :rede, optional: true
  has_many :users, dependent: :nullify

  validates :nome, :slug, :schema_name, presence: true
  validates :slug, :schema_name, uniqueness: true

  after_create_commit :create_schema
  before_validation :generate_identifiers, on: :create

  private

  def generate_identifiers
    return if nome.blank?

    identifier = parametize_nome

    self.slug ||= identifier
    self.schema_name ||= "tenant_"+identifier
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
end
