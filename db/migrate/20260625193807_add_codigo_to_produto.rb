class AddCodigoToProduto < ActiveRecord::Migration[8.1]
  def change
    add_column :produtos, :codigo, :string, null: false

    add_index :produtos, :codigo, unique: true
  end
end
