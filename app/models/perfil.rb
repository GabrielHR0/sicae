class Perfil < ApplicationRecord
  belongs_to :user, inverse_of: :perfil

  validates :cpf, presence: true, uniqueness: true, length: { is: 11 }
end
