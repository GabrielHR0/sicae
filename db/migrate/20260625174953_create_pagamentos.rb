class CreatePagamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :pagamentos do |t|
      t.references :lancamento, polymorphic: true, null: false

      t.references :forma_pagamento,
                   null: false,
                   foreign_key: { to_table: :formas_pagamento }

      t.decimal :valor, precision: 10, scale: 2
      t.decimal :troco, precision: 10, scale: 2

      t.timestamps
    end
  end
end
