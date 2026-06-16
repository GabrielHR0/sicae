FactoryBot.define do
  factory :item_preco do
    tabela_preco { nil }
    produto { nil }
    preco { "9.99" }
  end
end
