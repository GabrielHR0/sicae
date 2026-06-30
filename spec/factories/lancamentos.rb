FactoryBot.define do
  factory :lancamento do
    association :cantina

    trait :como_compra do
      type { "Compra" }
    end

    trait :como_fatura do
      type { "Fatura" }
      association :responsavel
      data_vencimento { 30.days.from_now }
    end

    factory :compra, parent: :lancamento, class: "Compra" do
      type { "Compra" }
      association :estudante
    end

    factory :fatura, parent: :lancamento, class: "Fatura" do
      type { "Fatura" }
      association :responsavel
      data_vencimento { 30.days.from_now }
    end
  end
end
