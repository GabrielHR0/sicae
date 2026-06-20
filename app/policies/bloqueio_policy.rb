# app/policies/bloqueio_policy.rb
class BloqueioPolicy < ApplicationPolicy
  def new?     = user.responsavel? && pertence_ao_responsavel?
  def create?  = new?
  def destroy? = user.responsavel? && pertence_ao_responsavel?

  private

  # Garante que o responsável só pode bloquear/desbloquear itens de estudantes vinculados a ele mesmo
  def pertence_ao_responsavel?
    record.responsavel_id.nil? || record.responsavel_id == user.responsavel&.id
  end
end
