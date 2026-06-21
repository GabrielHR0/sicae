# app/models/bloqueio.rb
class Bloqueio < ApplicationRecord
  belongs_to :responsavel
  belongs_to :estudante
  belongs_to :produto

  enum :tipo_periodo, {
    apenas_hoje: 0,
    ate_sexta: 1,
    indefinido: 2,
    personalizado: 3
  }

  validates :data_inicio, presence: true
  validates :tipo_periodo, presence: true
  validate :data_fim_obrigatoria_se_personalizado

  scope :ativos, -> { where("data_fim IS NULL OR data_fim >= ?", Date.today) }
  scope :para_estudante, ->(estudante_id) { where(estudante_id: estudante_id) }
  scope :para_produto, ->(produto_id) { where(produto_id: produto_id) }

  def ativo?
    data_fim.nil? || data_fim >= Date.today
  end

  private

  def data_fim_obrigatoria_se_personalizado
    if personalizado? && data_fim.blank?
      errors.add(:data_fim, "é obrigatória para período personalizado")
    end
  end
end
