class LandingController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :ensure_escola
  layout "landing"

  before_action :redirect_if_signed_in

  def index
  end

  private

  def allow_browser(versions:, block:)
  end

  def redirect_if_signed_in
    if user_signed_in?
      if current_user.escola.present?
        redirect_to dashboard_path
      else
        redirect_to new_escola_path
      end
    end
  end
end
