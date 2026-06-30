class ItemPreco < ApplicationRecord
  self.primary_key = :id

  belongs_to :tabela_preco
  belongs_to :produto

  validates :preco, numericality: { greater_than_or_equal_to: 0.0 }, presence: true
  validates :produto_id, uniqueness: { scope: :tabela_preco_id, message: "já está nesta tabela" }
end
