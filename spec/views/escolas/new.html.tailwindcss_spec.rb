require 'rails_helper'

RSpec.describe "escolas/new", type: :view do
  before(:each) do
    assign(:escola, Escola.new(
      nome: "MyString",
      slug: "MyString",
      schema_name: "MyString",
      cnpj: "MyString",
      email: "MyString",
      telefone: "MyString",
      ativo: false,
      metadata: ""
    ))
  end

  it "renders new escola form" do
    render

    assert_select "form[action=?][method=?]", escolas_path, "post" do

      assert_select "input[name=?]", "escola[nome]"

      assert_select "input[name=?]", "escola[slug]"

      assert_select "input[name=?]", "escola[schema_name]"

      assert_select "input[name=?]", "escola[cnpj]"

      assert_select "input[name=?]", "escola[email]"

      assert_select "input[name=?]", "escola[telefone]"

      assert_select "input[name=?]", "escola[ativo]"

      assert_select "input[name=?]", "escola[metadata]"
    end
  end
end
