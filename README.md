# SICAE

Sistema inteligente para cantinas escolares (multi‑tenant).

## Setup

### Sem Docker

```bash
cp .env.example .env          # ajuste credenciais do banco
bundle install
bin/rails db:create db:migrate db:seed
bin/rails db:migrate:tenants   # cria os schemas das escolas
```

### Com Docker

```bash
docker compose -f docker-compose.dev.yml up --build -d
docker compose -f docker-compose.dev.yml exec dev bin/rails db:create db:migrate db:seed
docker compose -f docker-compose.dev.yml exec dev bin/rails db:migrate:tenants
```

O app roda em `http://localhost:3000`.

## Acessar o sistema

O primeiro segmento da URL é a **slug da escola** (ex.: `instituto-estrela-da-manha1a2b`).

```bash
# Descubra a slug
docker compose -f docker-compose.dev.yml exec dev bin/rails runner "puts Escola.first.slug"
# Sem Docker:
bin/rails runner "puts Escola.first.slug"
```

Acesse `http://localhost:3000/{slug}/dashboard`.

Seed padrão:
| Campo | Valor |
|---|---|
| URL | `/{slug}/dashboard` |
| Login (username) | `teste123` |
| Login (email) | `teste@exemplo.com` |
| Senha | `123456` |

## Comandos

| Ação | Sem Docker | Com Docker (`exec dev`) |
|---|---|---|
| Servidor + Tailwind | `bin/dev` | (já sobe com `compose up`) |
| Testes | `bundle exec rspec` | `bundle exec rspec` |
| Lint | `bin/rubocop` | `bin/rubocop` |
| Console | `bin/rails console` | `bin/rails console` |
| Migrar schema `public` | `bin/rails db:migrate` | `bin/rails db:migrate` |
| Migrar tenants | `bin/rails db:migrate:tenants` | `bin/rails db:migrate:tenants` |
| Seeds | `bin/rails db:seed` | `bin/rails db:seed` |
| Seed específico | `bin/rails runner db/seeds/test/02_categorias.rb` | `bin/rails runner db/seeds/test/02_categorias.rb` |

## Criar nova página

1. **Model + migration**: `bin/rails g model Foo nome:string descricao:text`
2. **Migre os tenants**: `bin/rails db:migrate:tenants` (a migration roda no schema `public`; o `TenantSchemaManager` a replica nos tenants)
3. **Policy**: `app/policies/foo_policy.rb` com Pundit (`authorize @foo` no controller)
4. **Controller**: herde de `ApplicationController`, use `after_action :verify_authorized`
5. **Rotas**: `resources :foos` em `config/routes.rb`
6. **Views** (seguir o padrão DataTableable):
   - `app/views/foos/index.html.erb` — use `render 'shared/admin/data_table'`
   - `app/views/foos/_form.html.erb` — campos do formulário
   - `app/views/foos/_details.html.erb` — detalhes do registro
   - `app/views/foos/show.html.erb` — página de show
   - `app/views/foos/new.html.erb` e `edit.html.erb` — delegam ao form
7. **Adicione ao menu**: no `menu_groups` em `app/views/shared/admin/_side_bar.html.erb`
