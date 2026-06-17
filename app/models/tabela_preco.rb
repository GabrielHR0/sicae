class TabelaPreco < ApplicationRecord
  has_many :item_precos

  validates :nome, presence: true

  enum :status, {
    inativo: 0,
    ativo: 1,
    rascunho: 2
  }

  enum :tipo, {
    base: 0,
    personalizada: 1,
    promocional: 2
  }
end
