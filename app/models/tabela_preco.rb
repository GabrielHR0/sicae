class TabelaPreco < ApplicationRecord
  has_many :item_precos
  validates :nome, presence: true
  validate :only_one_base, on: :create

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

  before_destroy :prevent_base_destroy
  before_save :ensure_base_active

  private

  def only_one_base
    if tipo == "base" && TabelaPreco.exists?(tipo: :base)
      errors.add(:tipo, "já existe uma tabela base. Apenas uma é permitida.")
    end
  end

  def prevent_base_destroy
    if base?
      errors.add(:base, "Tabelas base não podem ser removidas.")
      throw :abort
    end
  end

  def ensure_base_active
    if base?
      self.status = :ativo
    end
  end
end
