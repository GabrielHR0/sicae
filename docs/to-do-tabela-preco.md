# To-Do: Tabela de Preço

## 1. Index em cards com paginação simples

- [ ] Criar partial `_card.html.erb` para cada tabela (nome, tipo, status, vigência, qtd produtos)
- [ ] Refatorar `TabelaPrecosController#index` com Pagy offset simples (`pagy(TabelaPreco.all, items: 12)`)
- [ ] View `index.html.erb` com grid de cards + navegação anterior/próximo

## 2. Tela de detalhe com ItemPreco em data table

- [ ] View `show.html.erb` — topo com dados da tabela + botões; abaixo data table com `ItemPreco`
- [ ] Controller `show` carregar `@pagy, @records = paginate_data_table(@tabela_preco.item_precos.includes(:produto))`
- [ ] Colunas: Produto (nome), Preço, Ações

## 3. CRUD de ItemPreco

- [ ] Rotas aninhadas: `resources :tabela_precos do resources :item_precos, only: %i[create update destroy] end`
- [ ] `ItemPrecosController` com create/update/destroy via Turbo
- [ ] Partial `_item_preco_form.html.erb` (select de produto + input de preço)
- [ ] Ação "Novo Item" no data table → modal com form
- [ ] Ações editar/excluir inline na data table

## 4. Ajustes finos

- [ ] Entrada "Tabelas de Preço" no menu lateral
- [ ] Corrigir callback do `Produto` (`criar_preco_base` / `atualizar_preco_base`) para não duplicar `ItemPreco`
- [ ] Badge de quantidade de produtos no card
- [ ] `TabelaPrecoPolicy` com Pundit
