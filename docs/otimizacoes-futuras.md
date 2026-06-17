# Otimizações futuras

## N+1 no preço dos produtos

O método `Produto#preco` dispara uma query individual por produto ao buscar
o valor na tabela de preços vigente. Na listagem de produtos, isso gera
N+1 consultas.

**Solução:** usar `left_joins(:item_precos)` + `select` no controller
`ProdutosController#index` para buscar todos os preços em uma única query,
ou criar um scope/association eager-loadable no modelo.

**Prioridade:** baixa — aplicar apenas se a página de produtos apresentar
lentidão perceptível.
