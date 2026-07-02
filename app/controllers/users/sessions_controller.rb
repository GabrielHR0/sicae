class Users::SessionsController < Devise::SessionsController
  before_action :set_escola_slug, only: [ :new ]

  def create
    self.resource = warden.authenticate!(auth_options)

    if resource && Current.escola.present? && resource.escola_id != Current.escola.id
      warden.logout
      flash[:alert] = "Esta conta não pertence a esta escola."
      redirect_to new_user_session_path and return
    end

    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  private

  def set_escola_slug
    @escola_slug = Current.escola&.slug
  end

  def after_sign_in_path_for(resource)
    if resource.escola.present?
      stored_location_for(resource) || dashboard_path
    else
      new_escola_path
    end
  end
end
