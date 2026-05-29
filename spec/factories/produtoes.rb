FactoryBot.define do
  factory :produto do
    nome { "MyString" }
    descricao { "MyText" }
    preco { "9.99" }
    categoria { "MyString" }
    estoque { 1 }
    ativo { false }
  end
end
