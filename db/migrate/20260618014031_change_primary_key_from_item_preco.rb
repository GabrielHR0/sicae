class ChangePrimaryKeyFromItemPreco < ActiveRecord::Migration[8.1]
  def change
    
    execute "ALTER TABLE item_precos DROP CONSTRAINT item_precos_pkey"
    execute "ALTER TABLE item_precos ADD PRIMARY KEY (tabela_preco_id, produto_id)"
  end
end
