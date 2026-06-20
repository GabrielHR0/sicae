class CreateCardapioProdutos < ActiveRecord::Migration[8.1]
  def change
    create_table :cardapio_produtos do |t|
      t.references :cardapio, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true

      t.timestamps
    end

    add_index :cardapio_produtos, [:cardapio_id, :produto_id], unique: true
  end
end
