class EscolaPolicy < ApplicationPolicy
  def index?   = user.admin?
  def show?    = user.admin?
  def update?  = user.admin?
  def edit?    = update?
  def destroy? = user.admin?

  class Scope < ApplicationPolicy::Scope
  end
end
