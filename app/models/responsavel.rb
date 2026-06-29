class Responsavel < ApplicationRecord
  belongs_to :user
  has_many :bloqueios, dependent: :destroy
  has_many :reservas, dependent: :destroy
  has_many :estudantes, dependent: :restrict_with_error
  has_many :faturas, class_name: "Fatura", dependent: :destroy

  enum :relacao_parental, {
    pai: 0,
    mae: 1,
    tutor: 2,
    outro: 3
  }
<<<<<<< Updated upstream
  
=======

>>>>>>> Stashed changes
end
