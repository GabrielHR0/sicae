class CreateItemPrecos < ActiveRecord::Migration[8.1]
  def change
    create_table :item_precos do |t|
      t.references :tabela_preco, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.decimal :preco, precision: 10, scale: 2, null: false, default: 0.0

      t.timestamps
    end
  end
end
