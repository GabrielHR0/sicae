module Cantina
  class CardapioPolicy < ApplicationPolicy
    def index?   = user.admin? || user.funcionario?
    def show?    = user.admin? || user.funcionario?
    def new?     = user.admin? || user.funcionario?
    def create?  = user.admin? || user.funcionario?
    def edit?    = user.admin? || user.funcionario?
    def update?  = user.admin? || user.funcionario?
    def destroy? = user.admin?

    class Scope < ApplicationPolicy::Scope
    end
  end
end
