require "rails_helper"

RSpec.describe EscolasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/escolas").to route_to("escolas#index")
    end

    it "routes to #new" do
      expect(get: "/escolas/new").to route_to("escolas#new")
    end

    it "routes to #show" do
      expect(get: "/escolas/1").to route_to("escolas#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/escolas/1/edit").to route_to("escolas#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/escolas").to route_to("escolas#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/escolas/1").to route_to("escolas#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/escolas/1").to route_to("escolas#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/escolas/1").to route_to("escolas#destroy", id: "1")
    end
  end
end
