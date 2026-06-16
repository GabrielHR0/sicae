json.extract! item_preco, :id, :tabela_preco_id, :produto_id, :preco, :created_at, :updated_at
json.url item_preco_url(item_preco, format: :json)
