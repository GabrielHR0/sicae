class Perfil < ApplicationRecord
  has_one :user, dependent: :nullify

  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }
end
