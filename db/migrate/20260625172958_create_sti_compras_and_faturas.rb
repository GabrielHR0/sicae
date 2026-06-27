class CreateStiComprasAndFaturas < ActiveRecord::Migration[8.1]
  def change
    rename_table :compras, :lancamentos
    add_column :lancamentos, :type, :string, null: false
    change_column_default :lancamentos, :token, nil

    add_reference :lancamentos, :responsavel,
      foreign_key: { to_table: "public.responsaveis" },
      null: true
    add_column :lancamentos, :data_vencimento, :datetime

    rename_table :item_compras, :itens_lancamento
    if column_exists?(:itens_lancamento, :compra_id)
      rename_column :itens_lancamento, :compra_id, :lancamento_id
    end
  end
end