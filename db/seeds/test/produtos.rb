return unless Rails.env.development? || Rails.env.test?

require "faker"

Faker::Config.random = Random.new(20_260_530)

seed_items = [
  { nome: "Coxinha tradicional", categoria: "salgado", preco: 8.5, estoque: 40, ativo: true },
  { nome: "Pastel de carne", categoria: "salgado", preco: 10.0, estoque: 25, ativo: true },
  { nome: "Hambúrguer artesanal", categoria: "lanche", preco: 22.9, estoque: 18, ativo: true },
  { nome: "X-salada", categoria: "lanche", preco: 19.9, estoque: 15, ativo: true },
  { nome: "Refrigerante lata", categoria: "bebida", preco: 6.0, estoque: 60, ativo: true },
  { nome: "Suco natural", categoria: "bebida", preco: 9.5, estoque: 30, ativo: true },
  { nome: "Brigadeiro", categoria: "sobremesa", preco: 5.5, estoque: 50, ativo: true },
  { nome: "Pudim de leite", categoria: "sobremesa", preco: 7.5, estoque: 12, ativo: true },
  { nome: "Esfiha de queijo", categoria: "salgado", preco: 7.0, estoque: 28, ativo: true },
  { nome: "Café expresso", categoria: "bebida", preco: 4.5, estoque: 80, ativo: true },
  { nome: "Açaí pequeno", categoria: "sobremesa", preco: 14.9, estoque: 20, ativo: true },
  { nome: "Pão de queijo", categoria: "salgado", preco: 6.5, estoque: 45, ativo: false }
]

seed_items.each do |attrs|
  produto = Produto.find_or_initialize_by(nome: attrs[:nome])
  produto.assign_attributes(
    descricao: Faker::Lorem.sentence(word_count: 10),
    categoria: attrs[:categoria],
    preco: attrs[:preco],
    estoque: attrs[:estoque],
    ativo: attrs[:ativo]
  )
  produto.save!
end

puts "Produtos de teste carregados: #{seed_items.size}"