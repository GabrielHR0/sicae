require "rails_helper"

RSpec.describe TenantSwitcherMiddleware do
  subject(:middleware) { described_class.new(app) }
  let(:app) { ->(env) { [200, {"content-type" => "text/plain"}, [env["PATH_INFO"]]] } }
  let(:env) do
    Rack::MockRequest.env_for("/tenant1/some/path")
  end

  before { Current.reset }
  after { Current.reset }

  it "com slug válido" do
    allow(Escola).to receive(:find_by).and_return(
      Escola.new(slug: "tenant1", schema_name: "tenant1_schema")
    )

    status, headers, body = middleware.call(env)
    expect(body).to eq(["/some/path"])
  end

  it "com slug inválido" do
    allow(Escola).to receive(:find_by).and_return(nil)

    status, headers, body = middleware.call(env)
    expect(body).to eq(["/some/path"])
    expect(Current.escola).to be_nil
  end
end