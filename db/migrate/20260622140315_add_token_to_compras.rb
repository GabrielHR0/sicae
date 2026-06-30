class AddTokenToCompras < ActiveRecord::Migration[8.1]
  def change
    add_column :compras, :token, :string
    add_index :compras, :token, unique: true
  end
end
