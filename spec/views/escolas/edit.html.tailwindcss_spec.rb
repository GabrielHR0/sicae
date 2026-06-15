require 'rails_helper'

RSpec.describe "escolas/edit", type: :view do
  let(:escola) {
    Escola.create!(
      nome: "MyString",
      slug: "MyString",
      schema_name: "MyString",
      cnpj: "MyString",
      email: "MyString",
      telefone: "MyString",
      ativo: false,
      metadata: ""
    )
  }

  before(:each) do
    assign(:escola, escola)
  end

  it "renders the edit escola form" do
    render

    assert_select "form[action=?][method=?]", escola_path(escola), "post" do

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
