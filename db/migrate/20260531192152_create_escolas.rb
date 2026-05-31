class CreateEscolas < ActiveRecord::Migration[8.1]
  def change
    create_table :escolas do |t|
      t.string :nome, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :schema_name, null: false, index: { unique: true }
      t.string :cnpj, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :telefone, null: false
      t.boolean :ativo, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :escolas, :slug, unique: true
    add_index :escolas, :schema_name, unique: true
    add_index :escolas, :cnpj, unique: true
  end
end
