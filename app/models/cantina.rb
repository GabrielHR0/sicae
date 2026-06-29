class Cantina < ApplicationRecord
  has_many :lancamentos
  has_many :cardapios

  validates :codigo, presence: true, uniqueness: true
  has_many :users

  before_validation :set_codigo, on: :create

  private

  def set_codigo
    loop do
      self.codigo = SecureRandom.hex(5)
      break unless Cantina.exists?(codigo: codigo)
    end
  end
end
