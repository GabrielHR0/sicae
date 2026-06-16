require 'rails_helper'

RSpec.describe "tabela_precos/edit", type: :view do
  let(:tabela_preco) {
    TabelaPreco.create!(
      nome: "MyString",
      descricao: "MyString",
      tipo: 1,
      status: 1
    )
  }

  before(:each) do
    assign(:tabela_preco, tabela_preco)
  end

  it "renders the edit tabela_preco form" do
    render

    assert_select "form[action=?][method=?]", tabela_preco_path(tabela_preco), "post" do

      assert_select "input[name=?]", "tabela_preco[nome]"

      assert_select "input[name=?]", "tabela_preco[descricao]"

      assert_select "input[name=?]", "tabela_preco[tipo]"

      assert_select "input[name=?]", "tabela_preco[status]"
    end
  end
end
