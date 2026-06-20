require "rails_helper"

RSpec.describe RedesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/redes").to route_to("redes#index")
    end

    it "routes to #new" do
      expect(get: "/redes/new").to route_to("redes#new")
    end

    it "routes to #show" do
      expect(get: "/redes/1").to route_to("redes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/redes/1/edit").to route_to("redes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/redes").to route_to("redes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/redes/1").to route_to("redes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/redes/1").to route_to("redes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/redes/1").to route_to("redes#destroy", id: "1")
    end
  end
end
