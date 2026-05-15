FactoryBot.define do
  factory :estudante do
    matricula { "MyString" }
    turma { "MyString" }
    serie { 1 }
    data_nascimento { "2026-05-15" }
    responsavel { nil }
    nivel_escolaridade { 0 }
  end
end
