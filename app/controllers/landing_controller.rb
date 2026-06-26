class LandingController < ApplicationController
  layout "landing"

  before_action :redirect_if_signed_in

  def index
  end

  private

  def redirect_if_signed_in
    redirect_to dashboard_path if user_signed_in?
  end
end
