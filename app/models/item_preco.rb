class ItemPreco < ApplicationRecord
  self.primary_key = [:tabela_preco_id, :produto_id]
  belongs_to :tabela_preco
  belongs_to :produto

  validates :preco, numericality: { greater_than_or_equal_to: 0.0 }, presence: true
end
