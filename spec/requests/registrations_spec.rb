require "rails_helper"

RSpec.describe "User Registrations", type: :request do
  describe "POST /users/sign_up" do
    it "Registra um usuario válido" do
      params = {
        user: FactoryBot.attributes_for(:user)
      }

      expect {
        post user_registration_path, params: params
      }.to change(User, :count).by(1)

    expect(response).to have_http_status(:see_other) # Devise redireciona depois do cadastro
    end
  end
end
