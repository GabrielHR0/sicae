require 'rails_helper'

RSpec.describe "Reservas", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/reservas/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/reservas/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
