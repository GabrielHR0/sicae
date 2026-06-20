class CategoriaPolicy < ApplicationPolicy
  def index?   = user.admin? || user.funcionario?
  def show?    = user.admin? || user.funcionario?
  def new?     = user.admin? || user.funcionario?
  def create?  = user.admin? || user.funcionario?
  def edit?    = user.admin? || user.funcionario?
  def update?  = user.admin? || user.funcionario?
  def destroy? = user.admin?

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
