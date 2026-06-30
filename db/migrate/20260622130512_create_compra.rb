class CreateCompra < ActiveRecord::Migration[8.1]
  def change
    create_table :compras do |t|
      t.integer :status, default: 0
      t.decimal :valor_total, precision:10, scale: 2, null: false, default: 0.0
      t.references :cantina, null: false, foreign_key: true

      t.timestamps
    end
  end
end
