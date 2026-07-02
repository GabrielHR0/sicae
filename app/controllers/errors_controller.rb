class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def not_found
    render status: :not_found
  end
end
