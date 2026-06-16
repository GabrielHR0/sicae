require "rails_helper"

RSpec.describe TabelaPrecosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/tabela_precos").to route_to("tabela_precos#index")
    end

    it "routes to #new" do
      expect(get: "/tabela_precos/new").to route_to("tabela_precos#new")
    end

    it "routes to #show" do
      expect(get: "/tabela_precos/1").to route_to("tabela_precos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/tabela_precos/1/edit").to route_to("tabela_precos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/tabela_precos").to route_to("tabela_precos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/tabela_precos/1").to route_to("tabela_precos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/tabela_precos/1").to route_to("tabela_precos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/tabela_precos/1").to route_to("tabela_precos#destroy", id: "1")
    end
  end
end
