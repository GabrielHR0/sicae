class ReservaPolicy < ApplicationPolicy
  def create?  = user.responsavel? && pertence_ao_responsavel?
  def destroy? = user.responsavel? && pertence_ao_responsavel?

  private

  def pertence_ao_responsavel?
    record.responsavel_id.nil? || record.responsavel_id == user.responsavel&.id
  end
end
