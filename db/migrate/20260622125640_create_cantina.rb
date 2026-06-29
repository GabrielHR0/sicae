class CreateCantina < ActiveRecord::Migration[8.1]
  def change
    create_table :cantinas do |t|
      t.string :codigo, null: false
      t.string :nome

      t.timestamps
    end
    add_index :cantinas, :codigo, unique: true
  end
end
