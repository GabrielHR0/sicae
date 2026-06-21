require 'rails_helper'

RSpec.describe "Bloqueios", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/bloqueios/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/bloqueios/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/bloqueios/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
