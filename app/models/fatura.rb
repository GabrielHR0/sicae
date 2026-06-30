class Fatura < Lancamento
  belongs_to :responsavel
  validates :data_vencimento, presence: true
end
