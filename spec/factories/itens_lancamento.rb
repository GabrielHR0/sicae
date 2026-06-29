FactoryBot.define do
  factory :item_lancamento do
    association :lancamento
    association :produto
    quantidade { 1 }
    valor_unitario { 10.0 }
    sub_total { 10.0 }
  end
end
