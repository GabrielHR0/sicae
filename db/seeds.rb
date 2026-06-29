# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Dir[Rails.root.join("db/seeds/**/*.rb")].sort.each do |seed_file|
	load seed_file
end
<<<<<<< Updated upstream
=======

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
>>>>>>> Stashed changes
