require 'rails_helper'

RSpec.describe ItemLancamento, type: :model do
  describe "associacoes" do
    it "pertence a um lancamento" do
      item = build(:item_lancamento)
      expect(item.lancamento).to be_present
    end

    it "pertence a um produto" do
      item = build(:item_lancamento)
      expect(item.produto).to be_present
    end
  end
end
