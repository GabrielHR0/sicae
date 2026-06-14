class Escola < ApplicationRecord
  self.table_name = "public.escolas"

  belongs_to :rede, optional: true
  has_many :users, dependent: :nullify

  validates :nome, :schema_name, :slug, presence: true
  validates :slug, :schema_name, uniqueness: true

  after_create :create_schema

  private 

  def create_schema(schema_name)
    begin
      TenantSchemaManager.create_schema!(schema_name)
    rescue => e
      update!(metadata: metadata.merge("schema_status" => "error", "schema_error" => e.message))
    raise
    end
  end
end
