class Cardapio < ApplicationRecord
  has_many :cardapio_produtos, dependent: :destroy
  has_many :produtos, through: :cardapio_produtos

  validates :data, presence: true, uniqueness: true

  scope :ativos, -> { where(ativo: true) }
  scope :do_mes, ->(mes, ano) { where(data: Date.new(ano, mes).beginning_of_month..Date.new(ano, mes).end_of_month) }

  def self.para_semana(data_inicio)
    where(data: data_inicio..data_inicio + 4.days)
  end
end
