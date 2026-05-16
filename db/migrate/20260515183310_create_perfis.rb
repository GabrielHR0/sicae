class CreatePerfis < ActiveRecord::Migration[8.1]
  def change
    create_table :perfis do |t|
      t.string :nome
      t.string :cpf
      t.date :data_nascimento
      t.string :phone

      t.timestamps
    end
  end
end
