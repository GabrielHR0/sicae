class CreateCategorias < ActiveRecord::Migration[8.1]
  def change
    create_table :categorias do |t|
      t.string :nome, null: false
      t.text :descricao
      t.boolean :ativo, default: true, null: false

      t.timestamps
    end

    add_index :categorias, :nome, unique: true
    add_index :categorias, :ativo
  end
end
