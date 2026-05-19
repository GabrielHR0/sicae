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

Este projeto ja possui `docker-compose.yml` (banco + web) e `docker-compose.dev.yml` para desenvolvimento. O modo dev usa o servico `dev`, monta o codigo e executa `bin/dev` com hot reload.

1. Suba o ambiente de desenvolvimento:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

2. Acesse o app:

```bash
http://localhost:3000
```

Esse modo ja sobe o watcher do Tailwind (via `bin/dev`) e aplica mudancas em tempo real no CSS e no codigo.

### Comandos Rails dentro do container

Use o servico `dev` para rodar comandos do Rails dentro do container:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails db:create
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails db:migrate
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails db:seed
```

Outros exemplos:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails console
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails routes
```

Observacoes:
- Se preferir comandos pontuais sem manter o container aberto, use `run --rm` no lugar de `exec`.
- Caso o `bin/dev` nao suba por falta de dependencias (Node/Yarn), adicione as dependencias na imagem de dev ou crie uma `Dockerfile.dev`.

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
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails tailwindcss:build
```

Para assistir mudancas:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bin/rails tailwindcss:watch
```

## Testes e lint

Sem Docker:

```bash
bundle exec rspec
bundle exec rubocop
```

Com Docker (dev):

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bundle exec rspec
docker compose -f docker-compose.yml -f docker-compose.dev.yml exec dev bundle exec rubocop
```
