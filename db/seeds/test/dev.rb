require 'bcrypt'
require 'faker'
return unless Rails.env.development? || Rails.env.test?

encrypted_password = BCrypt::Password.create("123456")

escola_estrela = {
  atrivo: true,
  cnpj: "79.642.075/0001-26",
  email: "estrela@exemplo.com",
  nome: "Instituto Estrela Da Manhã",
  
}
user_base = {
  email: "teste@exemplo.com",
  username: "teste123",
  encrypted_password: encrypted_password
}

User.create!(user_base)
