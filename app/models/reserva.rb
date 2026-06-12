class Reserva < ApplicationRecord
  belongs_to :responsavel
  belongs_to :estudante
  belongs_to :produto

  validates :data, presence: true
  validates :produto_id, uniqueness: { scope: [:estudante_id, :data],
    message: "já reservado para este estudante nesta data" }
  validate :produto_nao_bloqueado

  scope :para_estudante, ->(estudante_id) { where(estudante_id: estudante_id) }
  scope :para_data, ->(data) { where(data: data) }

  private

  def produto_nao_bloqueado
    return unless estudante && produto

    bloqueio = Bloqueio.ativos
                       .para_estudante(estudante_id)
                       .para_produto(produto_id)
                       .first

    if bloqueio.present?
      errors.add(:base, "Este produto está bloqueado para este estudante")
    end
  end
end