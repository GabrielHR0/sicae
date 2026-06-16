require 'rails_helper'

RSpec.describe "escolas/show", type: :view do
  before(:each) do
    assign(:escola, Escola.create!(
      nome: "Nome",
      slug: "Slug",
      schema_name: "Schema Name",
      cnpj: "Cnpj",
      email: "Email",
      telefone: "Telefone",
      ativo: false,
      metadata: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/Schema Name/)
    expect(rendered).to match(/Cnpj/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Telefone/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
  end
end
