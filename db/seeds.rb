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

# Permissions - Vendas
venda_permissions = [
  { nome: "Criar venda", recurso: "venda", acao: "create", descricao: "Permite criar vendas na cantina" },
  { nome: "Cancelar venda", recurso: "venda", acao: "cancel", descricao: "Permite cancelar vendas" }
]

venda_permissions.each do |attrs|
  Permission.find_or_create_by!(recurso: attrs[:recurso], acao: attrs[:acao]) do |p|
    p.nome = attrs[:nome]
    p.descricao = attrs[:descricao]
  end
end

puts "Permissions de venda criadas"

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
