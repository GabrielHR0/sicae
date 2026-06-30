# SICAE — AGENTS.md

## Comportamento do agente

- **Responda sempre em português brasileiro.**
- **Nunca edite ou crie arquivos de código.** O usuário quer aprender escrevendo o próprio código.
- Atue como uma **wiki interativa**: explique conceitos, mostre exemplos, aponte documentação,
  sugira abordagens, mas deixe a implementação por conta do usuário.
- Se quiser mostrar um trecho de código, apresente como ilustração ou referência,
  nunca como solução pronta para colar. Prefira explicar o "porquê" em vez de dar o "como" pronto.

## Stack

- **Rails 8.1.2** / **Ruby 3.3.5** / **PostgreSQL**
- **Devise** (auth via email **or** username; `config.authentication_keys = [:login]`)
- **Pundit** (authorization), **Pagy** (offset pagination), **DataTableable** (search/sort concern)
- **Tailwind v4** + **Flowbite**, dark mode via `class`
- **Importmap** (no Webpack/Esbuild)
- **Hotwire** (Turbo + Stimulus)
- **Kamal** (Docker deploy), **Solid Queue/Cache/Cable** (production)

## Setup & dev

```bash
bundle install
cp .env.example .env            # edit DB creds if needed
bin/rails db:create db:migrate
bin/dev                          # = rails server + tailwind:watch
```

Docker dev: `docker compose -f docker-compose.dev.yml up --build`

## Commands

| Purpose | Command |
|---|---|
| Run all CI locally (style → security → test) | `bin/ci` |
| Lint | `bin/rubocop` |
| All tests | `bundle exec rspec` |
| Single spec | `bundle exec rspec spec/models/foo_spec.rb` |
| Tailwind build | `bin/rails tailwindcss:build` |
| Tailwind watch | `bin/rails tailwindcss:watch` |

## Multi-tenancy (PostgreSQL schemas)

- **Tenant switching**: `TenantSwitcherMiddleware` reads the first URL path segment as `slug`, looks up `Escola`, sets `schema_search_path` to that school's schema.
- **Global tables** (always in `public`): `users`, `escolas`, `redes`, `roles`, `permissions`, `perfis`, `responsaveis`, `estudantes`
- **Per‑tenant tables** (in school schema): `produtos`, `categorias`
- `User.table_name = "public.users"` and `Escola.table_name = "public.escolas"` force them to stay in public regardless of tenant context.
- `TenantSchemaManager` creates a school schema at `Escola` creation (reads `schema.rb`, strips global tables, `eval`s the rest inside the new schema).

## DB env vars

`database.yml` uses `SICAE_DATABASE_NAME/USERNAME/PASSWORD/HOST/PORT` with fallback to `DB_*`.


## Seeds

Seeds de desenvolvimento estão em `db/seeds/test/` e rodam por tenant (escola).

```bash
# Roles (globais, em public)
bin/rails db:seed

# Usuário + escola + role master (primeira execução)
bin/rails runner "load Rails.root.join('db/seeds/test/01_dev.rb')"

# Categorias (por escola)
bin/rails runner "load Rails.root.join('db/seeds/test/02_categorias.rb')"

# Produtos (por escola, pergunta quantidade no terminal)
bin/rails runner "load Rails.root.join('db/seeds/test/03_produtos.rb')"

# Ou tudo de uma vez:
bin/rails db:seed && \
bin/rails runner "load Rails.root.join('db/seeds/test/02_categorias.rb')" && \
PRODUTOS_COUNT=100 bin/rails runner "load Rails.root.join('db/seeds/test/03_produtos.rb')"
```

## Slug da escola

O `slug` é gerado a partir do nome + 4 hex aleatórios (ex.: `instituto-estrela-da-manhac920`).  
Para descobrir o slug atual:

```bash
bin/rails runner "puts Escola.pluck(:slug)"
```

Com o slug, acesse a escola via: `http://localhost:3000/<slug>/vendas`

## Known quirks

- `config/routes.rb` has **duplicate lines** for `resources :produtos` and `resources :categorias`.
- `app/models/escola.rb` `after_create :create_schema` has a **broken callback signature** — the method takes `schema_name` but the callback passes the record. It triggers but may not work as intended.
- `Procfile.dev` has a **duplicate** `css:` line.
- `ProdutosController` has `authenticate_user!` and `verify_authorized` **commented out** — auth is bypassed for that controller.
- Devise password length: `6..128` (not the default).
- Default locale: `pt-BR`.
