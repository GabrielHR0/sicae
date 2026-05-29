# Planejamento de multitenancy (schema por escola)

## Documentos relacionados
- Implementacao: ./implementacao-multitenancy.md
- Middleware: ./middleware-tenant-schema.md

## Objetivo
Garantir isolamento forte de dados entre escolas, com integracao entre filiais e cantinas da mesma escola, usando um unico banco Postgres e um schema por escola.

## Nomenclatura (para pesquisa)
- Multitenancy: arquiteturas com isolamento por tenant.
- Tenant: escola como unidade de isolamento.
- Tenant resolver: resolucao do tenant pelo host ou sessao.
- Tenant context: validacao de tenant em controllers.
- Schema per tenant: um schema por escola.
- `search_path`: configuracao do Postgres para alternar schemas.
- Database RLS (Row Level Security): alternativa de isolamento por linha.
- Domain-based tenancy: identificacao por dominio/subdominio.

## Referencial teorico (resumo)
- Multitenancy pode ser implementado por nivel de isolamento:
  - Shared schema com coluna `tenant_id`.
  - Schema por tenant.
  - Banco por tenant.
- Quanto maior o isolamento, menor o risco de vazamento por erro de filtro, porem maior o custo operacional.
- O isolamento por schema oferece:
  - Separacao logica de dados no mesmo banco.
  - Menor custo que banco por tenant.
  - Necessidade de governanca de migracoes e mudanca de `search_path`.
- Principios de seguranca aplicados:
  - Menor privilegio: usuario do app acessa apenas schemas permitidos.
  - Definicao explicita do `search_path` por request.
  - Reset do `search_path` apos cada request.

## Decisao
- Estrategia: schema por escola.
- Motivos:
  - Isolamento maior que coluna.
  - Operacao mais simples que banco por escola.
  - Adequado para compliance com menor custo.

## Escopo do dominio
- `School`: raiz da escola (uma por tenant), armazenada em `public`.
- `SchoolUnit`: filiais (mesma escola), armazenadas no schema do tenant.
- `Canteen`: cantinas por unidade, armazenadas no schema do tenant.
- Entidades de negocio (ex.: `Product`, `Order`, `User`) armazenadas no schema do tenant.

## Separacao de dados
- Schema `public`:
  - `schools` e `school_domains`.
  - Informacoes globais e lookup de tenant.
- Schema do tenant (ex.: `school_12`):
  - Usuarios, pedidos, produtos, cantinas, unidades.

## Identificacao do tenant
Ordem sugerida:
1. Dominio customizado (ex.: `cantina.escola.com`).
2. Subdominio (ex.: `escola1.app.com`).
3. Selecao manual apos login (fallback).

## Como o usuario acessa o schema correto
Fluxo principal (recomendado):
1. O usuario acessa a aplicacao pelo dominio da escola.
2. O middleware resolve o tenant e define o `search_path`.
3. O login ocorre dentro do schema da escola, entao `users` pertence ao tenant.
4. Todas as requests seguintes herdam o mesmo schema via host.

Fluxo alternativo (selecao manual):
1. O usuario acessa um dominio neutro (ex.: `app.com`).
2. Faz login em um schema de autenticacao (publico) ou faz pre-login.
3. Seleciona a escola permitida.
4. O app grava `current_school_id` na sessao e passa a usar o schema correspondente.

Regra de governanca:
- O usuario so pode acessar schemas das escolas associadas ao seu perfil.
- Caso o tenant nao seja resolvido, bloquear rotas protegidas.

## Plano de execucao (passo a passo)
1. Criar tabelas globais `schools` e `school_domains` em `public`.
2. Implementar `TenantResolver` e `TenantSchemaSwitcher`.
3. Implementar o middleware de troca de schema e registrar no Rails.
4. Definir estrategia de identificacao do tenant (dominio, subdominio, ou sessao).
5. Implementar a governanca de acesso (rotas protegidas bloqueadas sem tenant).
6. Criar servico de criacao de tenant (schema + migrations).
7. Adicionar tarefa para migrar todos os schemas.
8. Ajustar seeds iniciais por tenant.
9. Adicionar logs de `tenant_schema` por request.
10. Validar com testes minimos de isolamento.

## Integracao entre filiais
- Todas as filiais da mesma escola compartilham o mesmo schema.
- Relatorios podem agregar todas as filiais sem risco de cruzar com outra escola.

## Riscos e mitigacoes
- Risco: `search_path` nao ser resetado.
  - Mitigacao: middleware garante `ensure` e reset.
- Risco: executar query fora do escopo do tenant.
  - Mitigacao: impedir acesso sem tenant resolvido (exceto paginas publicas).
- Risco: migracao parcial entre schemas.
  - Mitigacao: tarefa unica que percorre todos os schemas e falha de forma explicita.

## Politica de observabilidade
- Logar `tenant_schema` por request.
- Alarmes para requests sem tenant valido.

## Premissas
- Banco Postgres.
- Rails como app principal.
- Nao usar gems de multitenancy.
