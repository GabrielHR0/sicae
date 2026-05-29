class Produto < ApplicationRecord
  CATEGORIAS = %w[lanche bebida sobremesa salgado outro].freeze

  validates :nome, presence: true, length: { maximum: 100 }
  validates :preco, presence: true, numericality: { greater_than: 0 }
  validates :estoque, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :categoria, inclusion: { in: CATEGORIAS }, allow_blank: true

  scope :ativos, -> { where(ativo: true) }
  scope :inativos, -> { where(ativo: false) }
  scope :por_categoria, ->(cat) { where(categoria: cat) if cat.present? }

  def disponivel?
    ativo? && estoque > 0
  end
end
