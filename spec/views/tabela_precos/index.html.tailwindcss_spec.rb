require 'rails_helper'

RSpec.describe "tabela_precos/index", type: :view do
  before(:each) do
    assign(:tabela_precos, [
      TabelaPreco.create!(
        nome: "Nome",
        descricao: "Descricao",
        tipo: 2,
        status: 3
      ),
      TabelaPreco.create!(
        nome: "Nome",
        descricao: "Descricao",
        tipo: 2,
        status: 3
      )
    ])
  end

  it "renders a list of tabela_precos" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Descricao".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
  end
end
