class Categoria < ApplicationRecord
  has_many :produtos, dependent: :nullify
  # dependent: :nullify — para os produtos que não são deletados, só ficam sem categoria

  validates :nome, presence: true, uniqueness: true, length: { maximum: 50 }

  scope :ativas,   -> { where(ativo: true) }
  scope :inativas, -> { where(ativo: false) }
end
