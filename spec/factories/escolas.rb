FactoryBot.define do
  factory :escola do
    nome { "MyString" }
    slug { "MyString" }
    schema_name { "MyString" }
    cnpj { "MyString" }
    email { "MyString" }
    telefone { "MyString" }
    ativo { false }
    metadata { "" }
  end
end
