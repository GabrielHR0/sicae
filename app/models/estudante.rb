# app/models/estudante.rb
class Estudante < ApplicationRecord
  belongs_to :responsavel
  has_many :bloqueios, dependent: :destroy
  has_many :reservas, dependent: :destroy


  validates :nome, presence: true
end
