class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Pundit::Authorization
  include Pagy::Backend

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  stale_when_importmap_changes

  private

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar esta ação."
    redirect_to(request.referrer || root_path)
  end
end
