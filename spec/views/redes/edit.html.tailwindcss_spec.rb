require 'rails_helper'

RSpec.describe "redes/edit", type: :view do
  let(:rede) {
    Rede.create!(
      nome: "MyString",
      slug: "MyString",
      descricao: "MyText",
      metadata: "",
      ativo: false
    )
  }

  before(:each) do
    assign(:rede, rede)
  end

  it "renders the edit rede form" do
    render

    assert_select "form[action=?][method=?]", rede_path(rede), "post" do

      assert_select "input[name=?]", "rede[nome]"

      assert_select "input[name=?]", "rede[slug]"

      assert_select "textarea[name=?]", "rede[descricao]"

      assert_select "input[name=?]", "rede[metadata]"

      assert_select "input[name=?]", "rede[ativo]"
    end
  end
end
