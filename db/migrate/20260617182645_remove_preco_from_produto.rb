class RemovePrecoFromProduto < ActiveRecord::Migration[8.1]
  def change
    remove_column :produtos, :preco
  end
end
