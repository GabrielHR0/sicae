FactoryBot.define do
  factory :categoria do
    sequence(:nome) { |n| "Categoria #{format('%02d', n)}" }
    descricao { Faker::Lorem.sentence(word_count: 6) }
    ativo { true }
  end
end
