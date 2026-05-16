require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Testar factory" do
    it "deve criar um usuário válido" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end

  describe "Testar com nested attributes" do
    it "perfil deve ser criado junto com o usuário" do
      user = FactoryBot.build(:user, :with_perfil_nested)
      expect(user).to be_valid
      expect(user.perfil).to be_present
      expect(user.perfil.nome).to be_present
      expect(user.perfil.cpf).to be_present
      expect(user.perfil.telefone).to be_present
      expect(user.perfil.data_nascimento).to be_present
    end
  end
end
