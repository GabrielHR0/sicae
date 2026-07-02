# Roles
roles = [
  { nome: "admin", descricao: "Administrador do sistema" },
  { nome: "funcionario", descricao: "Funcionário da cantina" },
  { nome: "responsavel", descricao: "Responsável por estudante" },
  { nome: "aluno", descricao: "Estudante" }
]

roles.each do |attrs|
  Role.find_or_create_by!(nome: attrs[:nome]) do |r|
    r.descricao = attrs[:descricao]
  end
end

puts "Roles criadas: #{Role.pluck(:nome).join(', ')}"

# Permissions - todos os recursos baseados nas policies existentes
permissions = [
  # produto
  { nome: "Listar produtos", recurso: "produto", acao: "index", descricao: "Visualizar listagem de produtos" },
  { nome: "Ver produto", recurso: "produto", acao: "show", descricao: "Visualizar detalhes do produto" },
  { nome: "Criar produto", recurso: "produto", acao: "create", descricao: "Cadastrar novos produtos" },
  { nome: "Editar produto", recurso: "produto", acao: "update", descricao: "Atualizar dados do produto" },
  { nome: "Remover produto", recurso: "produto", acao: "destroy", descricao: "Excluir produtos" },

  # categoria
  { nome: "Listar categorias", recurso: "categoria", acao: "index", descricao: "Visualizar listagem de categorias" },
  { nome: "Ver categoria", recurso: "categoria", acao: "show", descricao: "Visualizar detalhes da categoria" },
  { nome: "Criar categoria", recurso: "categoria", acao: "create", descricao: "Cadastrar novas categorias" },
  { nome: "Editar categoria", recurso: "categoria", acao: "update", descricao: "Atualizar dados da categoria" },
  { nome: "Remover categoria", recurso: "categoria", acao: "destroy", descricao: "Excluir categorias" },

  # estudante
  { nome: "Listar estudantes", recurso: "estudante", acao: "index", descricao: "Visualizar listagem de estudantes" },
  { nome: "Ver estudante", recurso: "estudante", acao: "show", descricao: "Visualizar detalhes do estudante" },
  { nome: "Criar estudante", recurso: "estudante", acao: "create", descricao: "Cadastrar novos estudantes" },
  { nome: "Editar estudante", recurso: "estudante", acao: "update", descricao: "Atualizar dados do estudante" },
  { nome: "Remover estudante", recurso: "estudante", acao: "destroy", descricao: "Excluir estudantes" },

  # responsavel
  { nome: "Listar responsáveis", recurso: "responsavel", acao: "index", descricao: "Visualizar listagem de responsáveis" },
  { nome: "Ver responsável", recurso: "responsavel", acao: "show", descricao: "Visualizar detalhes do responsável" },
  { nome: "Criar responsável", recurso: "responsavel", acao: "create", descricao: "Cadastrar novos responsáveis" },
  { nome: "Editar responsável", recurso: "responsavel", acao: "update", descricao: "Atualizar dados do responsável" },
  { nome: "Remover responsável", recurso: "responsavel", acao: "destroy", descricao: "Excluir responsáveis" },

  # venda
  { nome: "Criar venda", recurso: "venda", acao: "create", descricao: "Permite criar vendas na cantina" },
  { nome: "Cancelar venda", recurso: "venda", acao: "cancel", descricao: "Permite cancelar vendas" },

  # bloqueio
  { nome: "Criar bloqueio", recurso: "bloqueio", acao: "create", descricao: "Bloquear produtos para estudantes" },
  { nome: "Remover bloqueio", recurso: "bloqueio", acao: "destroy", descricao: "Remover bloqueios de produtos" },

  # reserva
  { nome: "Criar reserva", recurso: "reserva", acao: "create", descricao: "Fazer reservas de produtos" },
  { nome: "Remover reserva", recurso: "reserva", acao: "destroy", descricao: "Cancelar reservas" },

  # cardapio (global)
  { nome: "Listar cardápios", recurso: "cardapio", acao: "index", descricao: "Visualizar listagem de cardápios" },
  { nome: "Ver cardápio", recurso: "cardapio", acao: "show", descricao: "Visualizar detalhes do cardápio" },

  # cantina/cardapio
  { nome: "Listar cardápios da cantina", recurso: "cantina/cardapio", acao: "index", descricao: "Visualizar cardápios da cantina" },
  { nome: "Ver cardápio da cantina", recurso: "cantina/cardapio", acao: "show", descricao: "Visualizar detalhes do cardápio da cantina" },
  { nome: "Criar cardápio na cantina", recurso: "cantina/cardapio", acao: "create", descricao: "Criar novos cardápios na cantina" },
  { nome: "Editar cardápio na cantina", recurso: "cantina/cardapio", acao: "update", descricao: "Atualizar cardápios da cantina" },
  { nome: "Remover cardápio na cantina", recurso: "cantina/cardapio", acao: "destroy", descricao: "Excluir cardápios da cantina" },

  # cantina/cardapio_produto
  { nome: "Adicionar produto ao cardápio", recurso: "cantina/cardapio_produto", acao: "create", descricao: "Vincular produtos a cardápios" },
  { nome: "Remover produto do cardápio", recurso: "cantina/cardapio_produto", acao: "destroy", descricao: "Desvincular produtos de cardápios" },

  # user
  { nome: "Listar usuários", recurso: "user", acao: "index", descricao: "Visualizar listagem de usuários" }
]

permissions.each do |attrs|
  Permission.find_or_create_by!(recurso: attrs[:recurso], acao: attrs[:acao]) do |p|
    p.nome = attrs[:nome]
    p.descricao = attrs[:descricao]
  end
end

puts "Permissions criadas: #{Permission.count}"

# Formas de Pagamento (por tenant)
formas = [
  { nome: "Dinheiro", tipo: 0, aceita_troco: true, ativo: true },
  { nome: "Fatura", tipo: 1, aceita_troco: false, ativo: true }
]

conn = ActiveRecord::Base.connection
previous_schema = conn.schema_search_path

Escola.all.each do |escola|
  conn.schema_search_path = escola.schema_name

  formas.each do |attrs|
    FormaPagamento.find_or_create_by!(nome: attrs[:nome]) do |fp|
      fp.tipo = attrs[:tipo]
      fp.aceita_troco = attrs[:aceita_troco]
      fp.ativo = attrs[:ativo]
    end
  end

  puts "Formas de pagamento criadas para #{escola.nome}"
end

conn.schema_search_path = previous_schema
