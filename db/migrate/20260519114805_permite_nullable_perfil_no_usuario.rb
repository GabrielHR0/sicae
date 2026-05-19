class PermiteNullablePerfilNoUsuario < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :perfil_id, :int, null: :true
  end
end
