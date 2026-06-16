class CreateReservas < ActiveRecord::Migration[8.1]
  def change
    create_table :reservas do |t|
      t.references :responsavel, null: false, foreign_key: true
      t.references :estudante, null: false, foreign_key: true
      t.references :produto, null: false, foreign_key: true
      t.date :data, null: false

      t.timestamps
    end

    add_index :reservas, [:estudante_id, :produto_id, :data], unique: true
  end
end