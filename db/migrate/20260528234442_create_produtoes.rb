class CreateProdutoes < ActiveRecord::Migration[8.1]
  def change
    create_table :produtos do |t|
      t.string :nome, null: false
      t.text :descricao
      t.decimal :preco, precision: 10, scale: 2, null: false
      t.string :categoria
      t.integer :estoque, default: 0, null: false
      t.boolean :ativo, default: true, null: false

      t.timestamps
    end

    add_index :produtos, :nome
    add_index :produtos, :ativo
  end
end
