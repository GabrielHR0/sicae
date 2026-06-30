require 'rails_helper'

RSpec.describe "Cantina::Cardapios", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/cantina/cardapios/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/cantina/cardapios/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/cantina/cardapios/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/cantina/cardapios/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/cantina/cardapios/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/cantina/cardapios/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
