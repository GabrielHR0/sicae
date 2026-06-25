class CreateItemCompra < ActiveRecord::Migration[8.1]
  def change
    create_table :item_compras do |t|
      t.integer :quantidade
      t.decimal :valor_unitario, precision:10, scale:2, null: false, default: 0.0
      t.decimal :sub_total, precision:10, scale:2, null: false, default: 0.0
      t.references :produto, null: false, foreign_key: true

      t.timestamps
    end
  end
end
