class CreateRedes < ActiveRecord::Migration[8.1]
  def change
    create_table :redes do |t|
      t.string :nome, null: false
      t.string :slug, null: false, index: { unique: true }
      t.text :descricao
      t.jsonb :metadata, null: false, default: {}
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end
  end
end
