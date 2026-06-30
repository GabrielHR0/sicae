class CantinaConfig < ApplicationRecord
  self.table_name = "cantinas"
  has_many :lancamentos
  has_many :cardapios
  has_many :users

  validates :codigo, presence: true, uniqueness: true

  before_validation :set_codigo, on: :create

  private

  def set_codigo
    loop do
      self.codigo = SecureRandom.hex(5)
      break unless CantinaConfig.exists?(codigo: codigo)
    end
  end
end
