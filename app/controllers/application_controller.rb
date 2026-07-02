class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Method

  before_action :authenticate_user!
  before_action :ensure_escola
  allow_browser versions: :modern

  after_action :verify_authorized, unless: :devise_or_pages?

  rescue_from Pundit::NotAuthorizedError do |e|
    respond_to do |format|
      format.json { render json: { erro: "Não autorizado" }, status: :forbidden }
      format.html { redirect_to(request.referrer || root_path, alert: "Sem permissão") }
    end
  end

  stale_when_importmap_changes

  def render(*args, **kwargs)
    status = kwargs[:status] || (args.first.is_a?(Hash) && args.first[:status])
    if (status == :unprocessable_entity || status == 422) && !request.format.json?
      errors = collect_model_errors
      flash.now[:alert] = errors if errors.any?
    end
    super
  end

  private

  def devise_or_pages?
    devise_controller? || self.class == ErrorsController || self.class == LandingController
  end

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

  def collect_model_errors
    instance_variables.each_with_object([]) do |ivar, errors|
      value = instance_variable_get(ivar)
      next unless value.respond_to?(:errors)
      model_errors = value.errors
      next if model_errors.nil?
      errors.concat(model_errors.full_messages) if model_errors.any?
    end
  end
end
