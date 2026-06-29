module Cantina
  class CardapioProdutoPolicy < ApplicationPolicy
    def create?  = user.admin? || user.funcionario?
    def destroy? = user.admin? || user.funcionario?

    class Scope < ApplicationPolicy::Scope
    end
  end
end
