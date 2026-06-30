class AddLancamentoRefToItensLancamento < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:itens_lancamento, :lancamento_id)
      add_column :itens_lancamento, :lancamento_id, :bigint
      add_index :itens_lancamento, :lancamento_id
    end
  end
end
