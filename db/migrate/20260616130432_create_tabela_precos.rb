class CreateTabelaPrecos < ActiveRecord::Migration[8.1]
  def change
    create_table :tabela_precos do |t|
      t.string :nome, null: false
      t.string :descricao
      t.integer :tipo, default: 0
      t.integer :status, default: 0
      t.datetime :inicioVigencia
      t.datetime :fimVigencia

      t.timestamps
    end
  end
end
