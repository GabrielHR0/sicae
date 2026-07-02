require 'rails_helper'

RSpec.describe Lancamento, type: :model do
  describe "validacoes" do
    it "cria um lancamento valido" do
      lancamento = build(:lancamento)
      expect(lancamento).to be_valid
    end
  end

  describe "enums" do
    it "define status como rascunho por padrao" do
      lancamento = build(:lancamento)
      expect(lancamento.status).to eq("rascunho")
    end
  end
end
