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