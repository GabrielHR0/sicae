module AuthorizationHelper
  def can?(resource, action = nil)
    current_user&.has_permission?(resource, action) || false
  end

  def cannot?(resource, action = nil)
    !can?(resource, action)
  end
end