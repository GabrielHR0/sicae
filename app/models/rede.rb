class Rede < ApplicationRecord
  has_many :escolas, dependent: :nullify

  validates :nome, :slug, presence: true
  validates :slug, uniqueness: true
end
