class ItemCompra < ApplicationRecord
  belongs_to :produto
  has_many
end