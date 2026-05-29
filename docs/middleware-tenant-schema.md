# Middleware de tenant (schema por escola)

## Documentos relacionados
- Planejamento: ./planejamento-multitenancy.md
- Implementacao: ./implementacao-multitenancy.md

## Objetivo
Garantir que cada request use o schema correto, com troca segura do `search_path` e reset ao final.

## Nomenclatura (para pesquisa)
- Middleware de tenant: troca de schema por request.
- `search_path`: configuracao de schema ativo no Postgres.
- Resolver por host: tenant via dominio/subdominio.
- Resolver por sessao: tenant via `current_school_id`.
- `schema_search_path`: configuracao da conexao no Rails.

## Fluxo
1. Recebe request.
2. Resolve tenant (dominio/subdominio e fallback por sessao).
3. Define `search_path` para `schema,public`.
4. Executa a aplicacao.
5. Restaura `search_path` original.

## Passo a passo
1. Criar `TenantResolver` e `SessionTenantResolver`.
2. Criar `TenantSchemaSwitcher`.
3. Criar `TenantSchemaMiddleware`.
4. Registrar o middleware no Rails.
5. Proteger controllers com `ensure_tenant`.

## Middleware

```ruby
# app/middleware/tenant_schema_middleware.rb
class TenantSchemaMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    school = TenantResolver.resolve(request.host)
    school ||= SessionTenantResolver.resolve(request.session)

    if school
      TenantSchemaSwitcher.use(school.schema_name) { @app.call(env) }
    else
      @app.call(env)
    end
  end
end
```

## Switcher seguro

```ruby
# app/services/tenant_schema_switcher.rb
class TenantSchemaSwitcher
  def self.use(schema)
    connection = ActiveRecord::Base.connection
    previous = connection.schema_search_path

    connection.schema_search_path = "#{schema},public"

    yield
  ensure
    connection.schema_search_path = previous
  end
end
```

## Registrar no Rails

```ruby
# config/application.rb
config.middleware.use TenantSchemaMiddleware
```

## Boas praticas
- Defina `search_path` apenas no middleware.
- Nunca altere `search_path` dentro de models.
- Logue o schema atual por request (ex.: `request_id`, `schema`).
- Bloqueie rotas protegidas sem tenant resolvido.

## Rotas publicas
Defina quais rotas podem rodar sem tenant (ex.: login, selecao de escola, healthcheck).
Qualquer rota protegida deve exigir tenant resolvido via `before_action`.

## Fallback por sessao (opcional)
Se o host nao identificar o tenant, use a sessao.

```ruby
# app/services/session_tenant_resolver.rb
class SessionTenantResolver
  def self.resolve(session)
    School.find_by(id: session[:current_school_id])
  end
end
```

Ajuste o middleware para tentar o host e, se falhar, usar a sessao.
