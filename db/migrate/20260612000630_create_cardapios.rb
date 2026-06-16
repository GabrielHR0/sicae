class CreateCardapios < ActiveRecord::Migration[8.1]
  def change
    create_table :cardapios do |t|
      t.date :data, null: false
      t.text :observacao
      t.boolean :ativo, default: true, null: false

      t.timestamps
    end

    add_index :cardapios, :data, unique: true
    add_index :cardapios, :ativo
  end
end
