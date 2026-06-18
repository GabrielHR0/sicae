class CreateBloqueios < ActiveRecord::Migration[8.1]
  def change
    create_table :bloqueios do |t|
      t.references :responsavel, null: false, foreign_key: true
      t.references :estudante, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.integer :tipo_periodo, null: false, default: 0
      t.date :data_inicio, null: false
      t.date :data_fim

      t.text :observacao

      t.timestamps
    end

    add_index :bloqueios, [:estudante_id, :produto_id]
  end
end
