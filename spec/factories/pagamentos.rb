FactoryBot.define do
  factory :pagamento do
    association :lancamento, factory: :compra
    association :forma_pagamento
    valor { 10.0 }
    troco { 0.0 }
  end
end
