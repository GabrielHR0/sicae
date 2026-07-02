class ItemPrecoPolicy < ApplicationPolicy
  def index?   = user.admin? || user.funcionario?
  def show?    = user.admin? || user.funcionario?
  def create?  = user.admin? || user.funcionario?
  def new?     = create?
  def update?  = user.admin? || user.funcionario?
  def edit?    = update?
  def destroy? = user.admin?

  class Scope < ApplicationPolicy::Scope
  end
end
