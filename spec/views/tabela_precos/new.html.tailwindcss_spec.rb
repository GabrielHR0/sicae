require 'rails_helper'

RSpec.describe "tabela_precos/new", type: :view do
  before(:each) do
    assign(:tabela_preco, TabelaPreco.new(
      nome: "MyString",
      descricao: "MyString",
      tipo: 1,
      status: 1
    ))
  end

  it "renders new tabela_preco form" do
    render

    assert_select "form[action=?][method=?]", tabela_precos_path, "post" do

      assert_select "input[name=?]", "tabela_preco[nome]"

      assert_select "input[name=?]", "tabela_preco[descricao]"

      assert_select "input[name=?]", "tabela_preco[tipo]"

      assert_select "input[name=?]", "tabela_preco[status]"
    end
  end
end
