require "rails_helper"

RSpec.describe ItemPrecoPolicy, type: :policy do
  subject { described_class }

  describe "autorizacao" do
    let(:record) { :item_preco }

    it "permite admin para index" do
      expect(subject.new(create(:user, :admin), record).index?).to be true
    end

    it "permite funcionario para index" do
      expect(subject.new(create(:user, :funcionario), record).index?).to be true
    end

    it "nega responsavel para index" do
      expect(subject.new(create(:user, :responsavel), record).index?).to be false
    end

    it "permite apenas admin para destroy" do
      expect(subject.new(create(:user, :admin), record).destroy?).to be true
      expect(subject.new(create(:user, :funcionario), record).destroy?).to be false
    end
  end
end
