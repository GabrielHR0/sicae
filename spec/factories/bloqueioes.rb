FactoryBot.define do
  factory :bloqueio do
    responsavel { nil }
    estudante { nil }
    produto { nil }
    tipo_periodo { 1 }
    data_inicio { "2026-06-11" }
    data_fim { "2026-06-11" }
    observacao { "MyText" }
  end
end
