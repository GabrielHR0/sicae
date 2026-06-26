class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include Pundit::Authorization
  include Pagy::Method

  rescue_from Pundit::NotAuthorizedError do |e|
    respond_to do |format|
      format.json { render json: { erro: "Não autorizado" }, status: :forbidden }
      format.html { redirect_to(request.referrer || root_path, alert: "Sem permissão") }
    end
  end

  stale_when_importmap_changes

  private

  def user_not_authorized
    flash[:alert] = "Você não tem permissão para realizar esta ação."
    redirect_to(request.referrer || root_path)
  end
end
