require 'rails_helper'

RSpec.describe Fatura, type: :model do
  describe "validacoes" do
    it "cria uma fatura valida" do
      fatura = build(:fatura)
      expect(fatura).to be_valid
      expect(fatura.type).to eq("Fatura")
    end

    it "requer data_vencimento" do
      fatura = build(:fatura, data_vencimento: nil)
      expect(fatura).not_to be_valid
    end

    it "pertence a um responsavel" do
      fatura = build(:fatura)
      expect(fatura.responsavel).to be_present
    end
  end
end
