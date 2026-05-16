class UserPolicy < ApplicationPolicy
  def index?
    user.present? && user.has_role?(:admin)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.all if user.present? && user.has_role?(:admin)

      scope.none
    end
  end
end
