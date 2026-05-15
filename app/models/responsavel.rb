class Responsavel < ApplicationRecord
  belongs_to :perfil
  has_many :estudantes, dependent: :nullify

  enum relacao_parental: {
    pai: 0,
    mae: 1,
    tutor: 2,
    outro: 3
  }
end
