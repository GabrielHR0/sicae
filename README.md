# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Setup (development)

1. Install gems:

```bash
bundle install
```

2. Copy example env and edit if needed:

```bash
cp .env.example .env
# edit .env and set DB credentials if necessary
```

3. Create and migrate the database:

```bash
bin/rails db:create
bin/rails db:migrate
```

4. Start the app (example):

```bash
bin/rails server
```

Notes:
- The app reads `DATABASE_URL` automatically if set; the `config/database.yml` is configured to prefer explicit env vars when provided.
- Do not commit your `.env` file to version control.

## Rodar em desenvolvimento com Docker

Existem duas formas comuns de rodar o ambiente de desenvolvimento conteinerizado:

- Opção rápida (temporária): usa o serviço `web` do `docker-compose` para executar `bin/dev` com bind-mount do código.

```bash
# inicia apenas o banco
docker compose up -d db

# abre um container temporário ligado à mesma rede e expõe a porta 3000
docker compose run --service-ports web bin/dev
```

Observação: esse modo funciona se a imagem `web` tiver as dependências de desenvolvimento (Node/Yarn, ferramentas de assets). Se sua `Dockerfile` for orientada a produção, prefira a segunda opção.

- Opção recomendada: crie um arquivo `docker-compose.dev.yml` que sobrescreva o serviço para montar o código e executar `bin/dev` (watchers do Tailwind + hot reload).

Exemplo de `docker-compose.dev.yml`:

```yaml
services:
	dev:
		build:
			context: .
			dockerfile: Dockerfile
		command: bin/dev
		working_dir: /rails
		env_file:
			- .env
		volumes:
			- .:/rails:cached
			- bundle_cache:/usr/local/bundle
		ports:
			- "3000:3000"
		depends_on:
			- db

volumes:
	bundle_cache:
```

Suba com:

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build
```

Isso permite hot-reload do Rails e do Tailwind (via `bin/dev`) enquanto o código é editado localmente.

Se o `bin/dev` não rodar (falta Node/Yarn no container), adicione essas ferramentas à sua `Dockerfile` de desenvolvimento ou use uma `Dockerfile.dev` com dependências de desenvolvimento.

Fique atento a não commitar credenciais sensíveis no repositório quando usar `.env`.

### Tailwind

Se você alterar o `tailwind.config.js` ou as fontes de estilos, é necessário rebuildar o CSS dentro do container (o host pode não ter o `rails`/Node). Exemplos:

Rebuild único:

```bash
docker compose run --rm web bin/rails tailwindcss:build
```

Assistir mudanças (watch):

```bash
docker compose run --rm web bin/rails tailwindcss:watch
```

Se o serviço `web` já estiver em execução num container (ex.: `sicae-dev-1`), você também pode executar:

```bash
docker exec -it sicae-dev-1 bin/rails tailwindcss:build
```

Ou use `bin/dev` quando a imagem/container tiver Node/Yarn instalados para rodar watchers (Rails + Tailwind) em modo de desenvolvimento.
