return unless Rails.env.development? || Rails.env.test?

require "faker"

Faker::Config.random = Random.new(20_260_530)
DEFAULT_PRODUCTS_COUNT = 100

def seed_products_count
  explicit_value = ENV["PRODUCTS_COUNT"].presence || ENV["PRODUTOS_COUNT"].presence
  return explicit_value.to_i if explicit_value.present? && explicit_value.to_i.positive?

  return DEFAULT_PRODUCTS_COUNT unless $stdin.tty?

  print "Quantos produtos deseja gerar? [#{DEFAULT_PRODUCTS_COUNT}]: "
  input = STDIN.gets&.strip
  input_value = input.to_i
  input_value.positive? ? input_value : DEFAULT_PRODUCTS_COUNT
end

categories = Categoria.order(:nome).to_a
if categories.empty?
  raise "Nenhuma categoria encontrada para gerar produtos. Rode o seed de categorias antes."
end

count = seed_products_count

count.times do |index|
  sequence_number = format("%03d", index + 1)
  category = categories[index % categories.size]
  product_name = "Produto #{sequence_number} - #{Faker::Commerce.product_name}"

  produto = Produto.find_or_initialize_by(nome: product_name)
  produto.assign_attributes(
    descricao: Faker::Lorem.sentence(word_count: 10),
    preco: Faker::Commerce.price(range: 3.0..35.0),
    estoque: Faker::Number.between(from: 0, to: 120),
    ativo: Faker::Boolean.boolean(true_ratio: 0.85)
  )
  produto.categoria = category
  produto.save!
end

puts "Produtos de teste carregados: #{count}"