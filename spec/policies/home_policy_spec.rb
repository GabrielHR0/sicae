require "rails_helper"

RSpec.describe HomePolicy, type: :policy do
  subject { described_class }

  describe "autorizacao" do
    it "permite qualquer usuario autenticado para index" do
      expect(subject.new(create(:user), :home).index?).to be true
    end
  end
end
