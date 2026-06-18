# README

## Rodar sem Docker

1. Instale as gems:

```bash
bundle install
```

2. Copie o env de exemplo e ajuste se necessario:

```bash
cp .env.example .env
# edite .env e ajuste credenciais do banco se necessario
```

3. Crie e migre o banco:

```bash
bin/rails db:create
bin/rails db:migrate
```

4. Suba o app:

```bash
bin/rails server
```

Para rodar Rails + Tailwind juntos (watch em tempo real), use o `bin/dev`:

```bash
bin/dev
```

Notas:
- O app le `DATABASE_URL` se estiver definido; o `config/database.yml` prioriza variaveis de ambiente quando existirem.
- Nao commite o arquivo `.env`.

## Rodar com Docker (dev)

Este projeto possui um `docker-compose.dev.yml` proprio para desenvolvimento. Ele sobe o banco e o servico `dev`, monta o codigo e executa `bin/dev` com hot reload.

1. Suba o ambiente de desenvolvimento:

```bash
docker compose -f docker-compose.dev.yml up --build
```

2. Acesse o app:

```bash
http://localhost:3000
```

Esse modo ja sobe o watcher do Tailwind (via `bin/dev`) e aplica mudancas em tempo real no CSS e no codigo.

### Comandos Rails dentro do container

Use `exec` para rodar comandos no container ja rodando, ou `run --rm` para comandos avulsos.

```bash
# Criar banco de dados
docker compose -f docker-compose.dev.yml exec dev bin/rails db:create

# Rodar migrations do schema public
docker compose -f docker-compose.dev.yml exec dev bin/rails db:migrate

# Rodar migrations nos schemas dos tenants (escolas)
docker compose -f docker-compose.dev.yml exec dev bin/rails db:migrate:tenants

# Rodar seed padrao (db/seeds.rb)
docker compose -f docker-compose.dev.yml exec dev bin/rails db:seed

# Rodar seed especifica (caminho Unix dentro do container)
docker compose -f docker-compose.dev.yml exec dev bin/rails runner db/seeds/test/dev.rb
docker compose -f docker-compose.dev.yml exec dev bin/rails runner db/seeds/test/categorias.rb
docker compose -f docker-compose.dev.yml exec dev bin/rails runner db/seeds/test/produtos.rb
```

Outros exemplos:

```bash
docker compose -f docker-compose.dev.yml exec dev bin/rails console
docker compose -f docker-compose.dev.yml exec dev bin/rails routes
docker compose -f docker-compose.dev.yml exec dev bin/rails db:rollback
```

Para comandos avulsos (sem o container `dev` rodando):

```bash
docker compose -f docker-compose.dev.yml run --rm dev bin/rails db:migrate
docker compose -f docker-compose.dev.yml run --rm dev bin/rails runner db/seeds/test/dev.rb
```

Observacoes:
- Caminhos dentro do container sao **Unix** (`/`), nunca Windows (`\`).
- O `working_dir` do container e `/rails`, entao os caminhos sao relativos a raiz do projeto.
- Se preferir comandos pontuais sem manter o container aberto, use `run --rm` no lugar de `exec`.

## Tailwind (CSS)

Sem Docker:

```bash
bin/rails tailwindcss:build
```

Para assistir mudancas:

```bash
bin/rails tailwindcss:watch
```

Com Docker (dev):

```bash
docker compose -f docker-compose.dev.yml exec dev bin/rails tailwindcss:build
docker compose -f docker-compose.dev.yml exec dev bin/rails tailwindcss:watch
```

## Testes e lint

Sem Docker:

```bash
bundle exec rspec
bundle exec rubocop
```

Com Docker (dev):

```bash
docker compose -f docker-compose.dev.yml exec dev bundle exec rspec
docker compose -f docker-compose.dev.yml exec dev bundle exec rubocop
```

## Migrations

| Comando | Descricao |
|---|---|
| `bin/rails db:migrate` | Migra apenas o schema `public` (tabelas globais) |
| `bin/rails db:migrate:tenants` | Migra os schemas de todas as escolas (tenants) |
| `bin/rails db:rollback` | Reverte a ultima migration no schema `public` |
| `bin/rails db:create` | Cria o banco de dados |

Os tenants usam schemas separados no PostgreSQL. O `db:migrate` padrao so atinge o `public`. Use `db:migrate:tenants` para propagar as migracoes para todas as escolas existentes.
