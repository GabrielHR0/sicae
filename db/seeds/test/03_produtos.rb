return unless Rails.env.development? || Rails.env.test?

require "faker"

DEFAULT_PRODUCTS_COUNT = 100

ALIMENTOS = [
  "Coxinha", "Empada de Frango", "Pastel de Carne", "Risole", "Kibe",
  "Esfiha de Carne", "Pão de Queijo", "Enroladinho de Salsicha",
  "Hambúrguer Artesanal", "Misto Quente", "Cachorro-Quente Simples",
  "Cachorro-Quente Completo", "Bauru", "Sanduíche Natural de Frango",
  "Sanduíche Natural de Atum", "Americano", "X-Tudo", "X-Burger",
  "X-Salada", "X-Calabresa", "X-Frango", "Torrada com Manteiga",
  "Pão na Chapa", "Pão com Ovo", "Pão com Presunto e Queijo",
  "Pão com Mortadela", "Suco de Laranja Natural", "Suco de Limão",
  "Suco de Maracujá", "Suco de Uva Integral", "Suco de Goiaba",
  "Suco de Manga", "Suco de Abacaxi com Hortelã", "Suco de Morango",
  "Suco de Acerola", "Suco de Caju", "Suco de Melancia",
  "Suco Verde (Couve com Limão)", "Vitamina de Banana", "Vitamina de Morango",
  "Vitamina de Mamão", "Iogurte Natural", "Iogurte de Morango",
  "Leite Fermentado", "Água Mineral s/ Gás", "Água Mineral c/ Gás",
  "Refrigerante Cola", "Refrigerante Guaraná", "Refrigerante Laranja",
  "Refrigerante Limão", "Mate Natural", "Chá Gelado de Pêssego",
  "Chá Gelado de Limão", "Chá Mate", "Leite com Chocolate",
  "Chocolate Quente", "Pudim de Leite", "Doce de Abóbora com Coco",
  "Manjar Branco com Ameixa", "Bolo de Cenoura com Cobertura",
  "Bolo de Chocolate", "Bolo de Laranja", "Bolo de Fubá com Goiabada",
  "Bolo Formigueiro", "Bolo de Milho Verde", "Torta de Limão",
  "Torta de Maçã", "Torta de Morango", "Torta Holandesa",
  "Sorvete de Chocolate", "Sorvete de Baunilha", "Sorvete de Morango",
  "Sorvete de Creme com Passas", "Picolé de Frutas Vermelhas",
  "Picolé de Coco", "Gelatina de Morango", "Gelatina de Uva",
  "Salada de Frutas", "Fruta da Estação (Banana)", "Fruta da Estação (Maçã)",
  "Fruta da Estação (Pêra)", "Mousse de Maracujá", "Mousse de Chocolate",
  "Brigadeiro", "Beijinho", "Cajuzinho", "Olho-de-Sogra",
  "Quindim", "Pé-de-Moleque", "Torresmo", "Amendoim Torrado",
  "Castanha de Caju", "Castanha do Pará", "Biscoito de Polvilho Doce",
  "Biscoito de Polvilho Salgado", "Biscoito Recheado de Chocolate",
  "Biscoito Recheado de Morango", "Barra de Cereal", "Barra de Proteína",
  "Salgadinho de Milho (Queijo)", "Salgadinho de Milho (Presunto)",
  "Batata Chips", "Batata Palha", " Pipoca Doce", "Pipoca Salgada",
  "Chocolate ao Leite", "Chocolate Branco", "Bala de Caramelo",
  "Bala de Hortelã", "Pirulito", "Chiclete", "Paçoquinha",
  "Maria-Mole", "Cocada Branca", "Cocada Queimada", "Bombom de Morango",
  "Bombom de Coco", "Alfajor", "Waffer de Chocolate", "Waffer de Morango"
].freeze

def seed_products_count
  explicit_value = ENV["PRODUCTS_COUNT"].presence || ENV["PRODUTOS_COUNT"].presence
  return explicit_value.to_i if explicit_value.present? && explicit_value.to_i.positive?

  return DEFAULT_PRODUCTS_COUNT unless $stdin.tty?

  print "Quantos produtos deseja gerar? [#{DEFAULT_PRODUCTS_COUNT}]: "
  input = STDIN.gets&.strip
  input_value = input.to_i
  input_value.positive? ? input_value : DEFAULT_PRODUCTS_COUNT
end

conn = ActiveRecord::Base.connection
previous_schema = conn.schema_search_path

Escola.all.each do |escola|
  conn.schema_search_path = escola.schema_name

  categories = Categoria.order(:nome).to_a
  if categories.empty?
    raise "Nenhuma categoria encontrada para #{escola.nome}. Rode o seed de categorias antes."
  end

  count = seed_products_count

  count.times do |index|
    category = categories[index % categories.size]
    nome_alimento = ALIMENTOS[index % ALIMENTOS.size]
    sequence_number = format("%03d", index + 1)
    nome_produto = "#{nome_alimento} - #{sequence_number}"

    produto = Produto.find_or_initialize_by(nome: nome_produto)
    produto.assign_attributes(
      descricao: "Produto alimentício: #{nome_alimento}. Categoria: #{category.nome}.",
      preco: Faker::Commerce.price(range: 2.0..30.0),
      estoque: Faker::Number.between(from: 0, to: 120),
      ativo: Faker::Boolean.boolean(true_ratio: 0.85)
    )
    produto.categoria = category
    produto.save!
  end

  puts "Produtos carregados para #{escola.nome}: #{count}"
end

conn.schema_search_path = previous_schema
