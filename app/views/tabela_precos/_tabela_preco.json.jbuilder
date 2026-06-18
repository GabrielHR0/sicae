json.extract! tabela_preco, :id, :nome, :descricao, :tipo, :status, :inicioVigencia, :fimVigencia, :created_at, :updated_at
json.url tabela_preco_url(tabela_preco, format: :json)
