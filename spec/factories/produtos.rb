FactoryBot.define do
  factory :produto do
    sequence(:nome) { |n| "Produto #{format('%03d', n)}" }
    descricao { Faker::Lorem.sentence(word_count: 8) }
    preco { Faker::Commerce.price(range: 5.0..40.0) }
    estoque { 1 }
    ativo { true }

    association :categoria
  end
end
