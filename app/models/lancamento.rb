class Lancamento < ApplicationRecord
  has_secure_token
  enum :status, { rascunho: 0, confirmado: 1, pago: 2, cancelado: 3 }

  belongs_to :cantina, class_name: "CantinaConfig"
  belongs_to :estudante, optional: true
  has_many :itens_lancamento, class_name: "ItemLancamento", foreign_key: :lancamento_id, dependent: :destroy
  has_many :pagamentos, as: :lancamento, dependent: :destroy
end
