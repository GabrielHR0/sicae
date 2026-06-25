class CreatePagamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :pagamentos do |t|
      t.references :lancamento, polymorphic: true, null: false
      t.references :forma_pagamento, null: false, foreign_key: true
      t.decimal :valor
      t.decimal :troco

      t.timestamps
    end
  end
end
