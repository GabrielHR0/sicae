class AddCodigoToProduto < ActiveRecord::Migration[8.1]
  def up
    return if column_exists?(:produtos, :codigo)

    add_column :produtos, :codigo, :string

    Produto.reset_column_information
    Produto.find_each.with_index do |p, i|
      p.update_column :codigo, format('COD-%05d', i + 1)
    end

    change_column_null :produtos, :codigo, false
    add_index :produtos, :codigo, unique: true
  end

  def down
    remove_index :produtos, :codigo
    remove_column :produtos, :codigo
  end
end