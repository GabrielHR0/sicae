require 'bcrypt'
require 'faker'
return unless Rails.env.development? || Rails.env.test?

encrypted_password = BCrypt::Password.create("123456")

escola_estrela = {
  ativo: true,
  cnpj: "79.642.075/0001-26",
  email: "estrela@exemplo.com",
  nome: "Instituto Estrela Da Manhã",
  telefone: "999990000"
}

user_base = {
  email: "teste@exemplo.com",
  username: "teste123",
  password: encrypted_password
}

user = User.find_or_initialize_by(username: user_base[:username])
user.assign_attributes(user_base)
user.save!

escola = Escola.find_or_initialize_by(email: escola_estrela[:email])
escola.assign_attributes(escola_estrela)
escola.save!
user.update!(escola: escola)

# Criar cantina no schema da escola
conn = ActiveRecord::Base.connection
conn.execute("SET search_path TO #{escola.schema_name}")
cantina = Cantina.find_or_create_by!(nome: "Cantina Principal", codigo: SecureRandom.hex(5))
conn.execute("SET search_path TO public")

user.update!(cantina: cantina)

master_role = Role.find_or_create_by(nome: "master", descricao: "Role com todas as permissões para dev")
permissions = Permission.all
master_role.permissions = permissions

user.roles << master_role unless user.roles.include?(master_role)

puts "
Usuário criado: #{user.inspect}
email: teste@exemplo.com
username: teste123
senha:123456
Escola: #{escola.inspect}
Cantina: #{cantina.inspect}
"
