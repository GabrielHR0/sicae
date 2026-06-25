class CreateFormasPagamento < ActiveRecord::Migration[8.1]
  def change
    create_table :formas_pagamento do |t|
      t.string :nome, null: false
      t.integer :tipo, default: 0
      t.boolean :aceita_troco, default: nil
      t.boolean :ativo, default: true

      t.timestamps
    end
  end
end
