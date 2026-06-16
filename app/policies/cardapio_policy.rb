class CardapioPolicy < ApplicationPolicy
  def index? = user.responsavel?
  def show?  = user.responsavel?

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
