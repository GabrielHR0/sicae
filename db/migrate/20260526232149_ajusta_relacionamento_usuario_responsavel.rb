class AjustaRelacionamentoUsuarioResponsavel < ActiveRecord::Migration[8.1]
  def change
    remove_reference :responsaveis, :perfil, null: false, foreign_key: true
    add_reference :responsaveis, :user, null: false, foreign_key: true

    remove_reference :users, :perfil, null: false, foreign_key: true
    add_reference :perfis, :user, null: false, foreign_key: true
  end
end
