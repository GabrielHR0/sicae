require 'rails_helper'

RSpec.describe Compra, type: :model do
  describe "heranca" do
    it "herda de Lancamento" do
      expect(Compra.superclass).to eq(Lancamento)
    end

    it "cria uma compra valida" do
      compra = build(:compra)
      expect(compra).to be_valid
      expect(compra.type).to eq("Compra")
    end
  end
end
