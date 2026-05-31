class Produto < ApplicationRecord

  belongs_to :categoria, optional: true
  
  validates :nome, presence: true, length: { maximum: 100 }
  validates :preco, presence: true, numericality: { greater_than: 0 }
  validates :estoque, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  scope :ativos, -> { where(ativo: true) }
  scope :inativos, -> { where(ativo: false) }
  scope :por_nome_categoria, ->(nome_cat) {
    return all if nome_cat.blank?
    joins(:categoria).where("categorias.nome ILIKE ?", "%#{nome_cat.strip}%")
  }

  def disponivel?
    ativo? && estoque > 0
  end
  
end
