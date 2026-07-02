require "rails_helper"

RSpec.describe RedePolicy, type: :policy do
  subject { described_class }

  describe "autorizacao" do
    let(:record) { :rede }

    it "permite admin para index" do
      expect(subject.new(create(:user, :admin), record).index?).to be true
    end

    it "nega funcionario para index" do
      expect(subject.new(create(:user, :funcionario), record).index?).to be false
    end

    it "nega responsavel para index" do
      expect(subject.new(create(:user, :responsavel), record).index?).to be false
    end
  end
end
