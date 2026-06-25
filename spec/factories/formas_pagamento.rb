FactoryBot.define do
  factory :forma_pagamento do
    nome { "Dinheiro" }
    tipo { 0 }
    aceita_troco { true }
    ativo { true }
  end
end
