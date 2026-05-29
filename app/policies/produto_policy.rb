class ProdutoPolicy < ApplicationPolicy
  # Somente funcionário da cantina e admin podem ver produtos
  def index? = user.admin? || user.funcionario?
  def show?   = user.admin? || user.funcionario?

  # Somente funcionário da cantina e admin podem criar/editar
  def create?  = user.admin? || user.funcionario?
  def new?     = create?
  def update?  = user.admin? || user.funcionario?
  def edit?    = update?

  # Somente admin pode destruir
  def destroy? = user.admin?
end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
