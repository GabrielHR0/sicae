class AddPerfilToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :perfil, null: false, foreign_key: true
  end
end
