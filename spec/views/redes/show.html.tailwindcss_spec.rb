require 'rails_helper'

RSpec.describe "redes/show", type: :view do
  before(:each) do
    assign(:rede, Rede.create!(
      nome: "Nome",
      slug: "Slug",
      descricao: "MyText",
      metadata: "",
      ativo: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Slug/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
