class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.string :nome
      t.string :descricao

      t.timestamps
    end

    add_index :roles, :nome, unique: true
  end
end
