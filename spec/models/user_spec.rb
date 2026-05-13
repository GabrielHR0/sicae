require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Testar factory" do
    it "deve criar um usuário válido" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end
end
