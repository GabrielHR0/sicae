class AddReferenceCompraToItemCompra < ActiveRecord::Migration[8.1]
  def change
    add_reference :item_compras, :compra
  end
end
