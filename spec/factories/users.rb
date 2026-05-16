FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :with_perfil_nested do
      perfil_attributes do
        {
          nome: Faker::Name.name,
          cpf: Faker::Number.number(digits: 11).to_s,
          telefone: Faker::PhoneNumber.cell_phone,
          data_nascimento: 20.years.ago.to_date
        }
      end
    end
  end
end
