require 'rails_helper'

RSpec.describe "tabela_precos/show", type: :view do
  before(:each) do
    assign(:tabela_preco, TabelaPreco.create!(
      nome: "Nome",
      descricao: "Descricao",
      tipo: 2,
      status: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome/)
    expect(rendered).to match(/Descricao/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
