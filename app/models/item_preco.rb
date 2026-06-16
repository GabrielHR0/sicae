class ItemPreco < ApplicationRecord
  belongs_to :tabela_preco
  belongs_to :produto
end
