FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username(specifier: 6..15) }
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

    trait :admin do
      after(:create) do |user|
        role = Role.find_or_create_by!(nome: "admin") { |r| r.descricao = "Administrador" }
        user.roles << role unless user.roles.include?(role)
      end
    end

    trait :funcionario do
      after(:create) do |user|
        role = Role.find_or_create_by!(nome: "funcionario") { |r| r.descricao = "Funcionario" }
        user.roles << role unless user.roles.include?(role)
      end
    end

    trait :responsavel do
      after(:create) do |user|
        role = Role.find_or_create_by!(nome: "responsavel") { |r| r.descricao = "Responsavel" }
        user.roles << role unless user.roles.include?(role)
      end
    end
  end
end
