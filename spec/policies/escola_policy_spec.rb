require "rails_helper"

RSpec.describe EscolaPolicy, type: :policy do
  subject { described_class }

  describe "autorizacao" do
    let(:record) { :escola }

    it "permite admin para index" do
      expect(subject.new(create(:user, :admin), record).index?).to be true
    end

    it "nega funcionario para index" do
      expect(subject.new(create(:user, :funcionario), record).index?).to be false
    end
  end
end
