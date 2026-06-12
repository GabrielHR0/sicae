class Responsavel < ApplicationRecord
  belongs_to :user
  has_many :estudantes, dependent: :nullify
  has_many :bloqueios, dependent: :destroy
  has_many :reservas, dependent: :destroy

  enum relacao_parental: {
    pai: 0,
    mae: 1,
    tutor: 2,
    outro: 3
  }
  
end
