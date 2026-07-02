require "rails_helper"

RSpec.describe VendaPolicy, type: :policy do
  subject { described_class }

  describe "autorizacao" do
    let(:record) { :venda }

    it "permite create com permissao" do
      user = create(:user, :admin)
      allow(user).to receive(:has_permission?).with("venda", "create").and_return(true)
      expect(subject.new(user, record).create?).to be true
    end

    it "nega create sem permissao" do
      user = create(:user, :admin)
      allow(user).to receive(:has_permission?).with("venda", "create").and_return(false)
      expect(subject.new(user, record).create?).to be false
    end

    it "permite cancel com permissao" do
      user = create(:user, :admin)
      allow(user).to receive(:has_permission?).with("venda", "cancel").and_return(true)
      expect(subject.new(user, record).cancel?).to be true
    end
  end
end
