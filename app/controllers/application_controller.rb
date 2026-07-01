class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Method

  before_action :authenticate_user!
  before_action :ensure_escola
  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError do |e|
    respond_to do |format|
      format.json { render json: { erro: "Não autorizado" }, status: :forbidden }
      format.html { redirect_to(request.referrer || root_path, alert: "Sem permissão") }
    end
  end

  stale_when_importmap_changes

  private

  def ensure_escola
    return unless current_user
    return if current_user.escola.present?
    return if controller_name == "escolas" && %w[new create].include?(action_name)
    return if devise_controller?

    redirect_to new_escola_path
  end

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar esta ação."
    redirect_to(request.referrer || root_path)
  end
end
