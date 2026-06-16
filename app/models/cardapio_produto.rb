class CardapioProduto < ApplicationRecord
  belongs_to :cardapio
  belongs_to :produto

  validates :cardapio_id, uniqueness: { scope: :produto_id }
end
