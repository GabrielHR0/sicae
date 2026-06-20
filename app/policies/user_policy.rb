class UserPolicy < ApplicationPolicy
  def index?
    user.present? && user.admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.present? && user.admin?

      scope.none
    end
  end
end
