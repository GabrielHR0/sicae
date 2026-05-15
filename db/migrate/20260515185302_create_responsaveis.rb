class CreateResponsaveis < ActiveRecord::Migration[8.1]
  def change
    create_table :responsaveis do |t|
      t.references :perfil, null: false, foreign_key: true
      t.integer :relacao_parental

      t.timestamps
    end
  end
end
