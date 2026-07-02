require "rails_helper"

RSpec.describe CantinaConfig, type: :model do
  describe "validacoes" do
    it "cria uma cantina valida" do
      cantina = build(:cantina)
      expect(cantina).to be_valid
    end

    it "gera codigo automaticamente ao criar" do
      cantina = create(:cantina)
      expect(cantina.codigo).to be_present
      expect(cantina.codigo.length).to eq(10)
    end
  end

  describe "associacoes" do
    it "tem muitos lancamentos" do
      assoc = CantinaConfig.reflect_on_association(:lancamentos)
      expect(assoc.macro).to eq(:has_many)
    end
  end
end
