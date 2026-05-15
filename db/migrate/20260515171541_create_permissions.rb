class CreatePermissions < ActiveRecord::Migration[8.1]
  def change
    create_table :permissions do |t|
      t.string :nome
      t.string :recurso
      t.string :acao
      t.string :descricao

      t.timestamps
    end

    add_index :permissions, :nome, unique: true
    add_index :permissions, [ :acao, :recurso ], unique: true
  end
end
