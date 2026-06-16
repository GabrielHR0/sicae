class AddRedeToEscolas < ActiveRecord::Migration[8.1]
  def change
    add_reference :escolas, :rede, null: true, foreign_key: true
  end
end
