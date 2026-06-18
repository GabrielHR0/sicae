return unless Rails.env.development? || Rails.env.test?

require "faker"

Faker::Config.random = Random.new(20_260_530)

seed_categories = [
  { nome: "Lanches", descricao: "Produtos rápidos para consumo", ativo: true },
  { nome: "Bebidas", descricao: "Bebidas frias e quentes", ativo: true },
  { nome: "Sobremesas", descricao: "Itens doces e finalização", ativo: true },
  { nome: "Salgados", descricao: "Lanches salgados preparados na hora", ativo: true },
  { nome: "Outros", descricao: "Itens diversos do catálogo", ativo: true }
]

conn = ActiveRecord::Base.connection
previous_schema = conn.schema_search_path

Escola.all.each do |escola|
  conn.schema_search_path = escola.schema_name

  seed_categories.each do |attrs|
    categoria = Categoria.find_or_initialize_by(nome: attrs[:nome])
    categoria.assign_attributes(
      descricao: attrs[:descricao],
      ativo: attrs[:ativo]
    )
    categoria.save!
  end

  puts "Categorias carregadas para #{escola.nome}: #{seed_categories.size}"
end

conn.schema_search_path = previous_schema
