class VendaPolicy < ApplicationPolicy
  def create?
    user.has_permission?("venda", "create")
  end

  def cancel?
    user.has_permission?("venda", "cancel")
  end
end
