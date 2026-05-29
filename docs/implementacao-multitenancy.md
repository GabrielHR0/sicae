# Implementacao pratica (schema por escola)

## Documentos relacionados
- Planejamento: ./planejamento-multitenancy.md
- Middleware: ./middleware-tenant-schema.md

## Passo a passo real
1. Criar tabelas globais em `public`.
2. Criar modelos globais.
3. Implementar resolucao de tenant.
4. Implementar troca de schema por request (middleware + switcher).
5. Registrar o middleware.
6. (Opcional) Implementar selecao manual de escola.
7. Criar servico de criacao de tenant.
8. Criar tarefa para migrar todos os schemas.
9. Criar modelos do tenant.
10. Ajustar seeds e logs.
11. Testar isolamento.

## Nomenclatura (para pesquisa)
- `TenantResolver`: resolve tenant pelo host.
- `SessionTenantResolver`: resolve tenant pela sessao.
- `TenantSchemaSwitcher`: troca o `search_path` com garantia de reset.
- `TenantSchemaMiddleware`: middleware que aplica o switch.
- `TenantContext`: concern que bloqueia rotas sem tenant.
- `school_domains`: tabela de mapeamento dominio -> escola.

## 1) Tabelas globais em `public`
Crie as tabelas para localizar o tenant.

```ruby
# db/migrate/xxxxxxxxxx_create_schools.rb
class CreateSchools < ActiveRecord::Migration[7.1]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.string :schema_name, null: false
      t.timestamps
    end

    add_index :schools, :schema_name, unique: true
  end
end
```

```ruby
# db/migrate/xxxxxxxxxx_create_school_domains.rb
class CreateSchoolDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :school_domains do |t|
      t.references :school, null: false, foreign_key: true
      t.string :domain, null: false
      t.timestamps
    end

    add_index :school_domains, :domain, unique: true
  end
end
```

## 2) Modelos globais

```ruby
# app/models/school.rb
class School < ApplicationRecord
  has_many :school_domains, dependent: :destroy
end
```

```ruby
# app/models/school_domain.rb
class SchoolDomain < ApplicationRecord
  belongs_to :school
  validates :domain, presence: true, uniqueness: true
end
```

## 3) Resolver o tenant pelo host

```ruby
# app/services/tenant_resolver.rb
class TenantResolver
  def self.resolve(host)
    SchoolDomain.includes(:school).find_by(domain: host)&.school
  end
end
```

## 3.1) Contexto do tenant no controller

```ruby
# app/controllers/concerns/tenant_context.rb
module TenantContext
  extend ActiveSupport::Concern

  included do
    before_action :ensure_tenant
  end

  private

  def ensure_tenant
    return if tenant_resolved?

    # bloqueia rotas protegidas quando nao ha tenant
    render plain: "Tenant nao resolvido", status: :forbidden
  end

  def tenant_resolved?
    TenantResolver.resolve(request.host).present?
  end
end
```

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  include TenantContext
end
```

## 4) Trocar o schema por request

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

```ruby
# app/middleware/tenant_schema_middleware.rb
class TenantSchemaMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    school = TenantResolver.resolve(request.host)

    if school
      TenantSchemaSwitcher.use(school.schema_name) { @app.call(env) }
    else
      @app.call(env)
    end
  end
end
```

## 4.1) Selecao manual de escola (fallback)
Quando o tenant nao pode ser inferido por host, use um dominio neutro e selecao explicita.

```ruby
# app/controllers/school_sessions_controller.rb
class SchoolSessionsController < ApplicationController
  skip_before_action :ensure_tenant, only: %i[new create]

  def new
    @schools = School.order(:name)
  end

  def create
    school = School.find(params[:school_id])
    session[:current_school_id] = school.id
    redirect_to root_path
  end
end
```

```ruby
# app/services/session_tenant_resolver.rb
class SessionTenantResolver
  def self.resolve(session)
    School.find_by(id: session[:current_school_id])
  end
end
```

Para usar o resolver por sessao, ajuste o middleware para tentar o host e, se falhar, usar a sessao:

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

Rotas para selecao manual:

```ruby
# config/routes.rb
resource :school_session, only: %i[new create]
```

## 5) Registrar o middleware

```ruby
# config/application.rb
config.middleware.use TenantSchemaMiddleware
```

## 6) Criar schema de uma nova escola

```ruby
# app/services/tenant_creator.rb
class TenantCreator
  def self.create!(school)
    connection = ActiveRecord::Base.connection
    schema = school.schema_name

    connection.execute("CREATE SCHEMA IF NOT EXISTS #{schema}")

    TenantSchemaSwitcher.use(schema) do
      ActiveRecord::Migrator.migrate(Rails.root.join("db/migrate"))
    end
  end
end
```

## 7) Migrations em todos os schemas

```ruby
# lib/tasks/tenants.rake
namespace :tenants do
  desc "Run migrations for all tenant schemas"
  task migrate: :environment do
    School.find_each do |school|
      TenantSchemaSwitcher.use(school.schema_name) do
        ActiveRecord::Migrator.migrate(Rails.root.join("db/migrate"))
      end
    end
  end
end
```

## 8) Exemplo de modelo tenant

```ruby
# app/models/canteen.rb
class Canteen < ApplicationRecord
  validates :name, presence: true
end
```

## 9) Fluxo de criacao de escola
1. Criar `School` e `SchoolDomain` em `public`.
2. Chamar `TenantCreator.create!` para criar o schema e rodar migrations.
3. Criar registros iniciais no schema da escola (seeds do tenant).

## 9.1) Seeds por tenant
Crie seeds que rodem dentro do schema do tenant:

```ruby
# db/seeds.rb
School.find_each do |school|
  TenantSchemaSwitcher.use(school.schema_name) do
    # seeds do tenant aqui
  end
end
```

## 10) Observabilidade
- Adicionar `tenant_schema` nos logs de request.
- Alertar quando nao houver tenant resolvido em rotas protegidas.

## 11) Testes minimos
- Request spec valida que `search_path` muda com host.
- Request spec valida isolamento entre duas escolas.

## Notas sobre o contexto atual
- Aplicacao Rails ja possui autenticacao (Devise). Se usar selecao manual apos login, armazene `current_school_id` na sessao.
- Controllers devem bloquear acesso sem tenant valido, exceto paginas publicas e fluxo de login.
