require "rails_helper"

RSpec.describe ItensprecoController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/item_precos").to route_to("item_precos#index")
    end

    it "routes to #new" do
      expect(get: "/item_precos/new").to route_to("item_precos#new")
    end

    it "routes to #show" do
      expect(get: "/item_precos/1").to route_to("item_precos#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/item_precos/1/edit").to route_to("item_precos#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/item_precos").to route_to("item_precos#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/item_precos/1").to route_to("item_precos#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/item_precos/1").to route_to("item_precos#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/item_precos/1").to route_to("item_precos#destroy", id: "1")
    end
  end
end
