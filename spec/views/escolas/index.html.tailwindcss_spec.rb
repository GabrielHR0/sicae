require 'rails_helper'

RSpec.describe "escolas/index", type: :view do
  before(:each) do
    assign(:escolas, [
      Escola.create!(
        nome: "Nome",
        slug: "Slug",
        schema_name: "Schema Name",
        cnpj: "Cnpj",
        email: "Email",
        telefone: "Telefone",
        ativo: false,
        metadata: ""
      ),
      Escola.create!(
        nome: "Nome",
        slug: "Slug",
        schema_name: "Schema Name",
        cnpj: "Cnpj",
        email: "Email",
        telefone: "Telefone",
        ativo: false,
        metadata: ""
      )
    ])
  end

  it "renders a list of escolas" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Slug".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Schema Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Cnpj".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Telefone".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
