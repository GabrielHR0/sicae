require 'rails_helper'

RSpec.describe "Cardapios", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/cardapios/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/cardapios/show"
      expect(response).to have_http_status(:success)
    end
  end

end
