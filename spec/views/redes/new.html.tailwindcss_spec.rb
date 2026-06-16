require 'rails_helper'

RSpec.describe "redes/new", type: :view do
  before(:each) do
    assign(:rede, Rede.new(
      nome: "MyString",
      slug: "MyString",
      descricao: "MyText",
      metadata: "",
      ativo: false
    ))
  end

  it "renders new rede form" do
    render

    assert_select "form[action=?][method=?]", redes_path, "post" do

      assert_select "input[name=?]", "rede[nome]"

      assert_select "input[name=?]", "rede[slug]"

      assert_select "textarea[name=?]", "rede[descricao]"

      assert_select "input[name=?]", "rede[metadata]"

      assert_select "input[name=?]", "rede[ativo]"
    end
  end
end
