class Lancamento < ApplicationRecord
  has_secure_token

  belongs_to :cantina
  belongs_to :estudante, optional: true
  has_many :itens_lancamento, class_name: "ItemLancamento", foreign_key: :lancamento_id, dependent: :destroy
end
