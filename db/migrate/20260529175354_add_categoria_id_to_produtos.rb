class AddCategoriaIdToProdutos < ActiveRecord::Migration[8.1]
  def change
    add_reference :produtos, :categoria, null: false, foreign_key: true
  end
end
