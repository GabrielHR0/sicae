class CreateEstudantes < ActiveRecord::Migration[8.1]
  def change
    create_table :estudantes do |t|
      t.string :matricula
      t.string :turma
      t.integer :serie
      t.date :data_nascimento
      t.references :responsavel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
