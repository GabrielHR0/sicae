require 'rails_helper'

RSpec.describe "item_precos/new", type: :view do
  before(:each) do
    assign(:item_preco, ItemPreco.new(
      tabela_preco: nil,
      produto: nil,
      preco: "9.99"
    ))
  end

  it "renders new item_preco form" do
    render

    assert_select "form[action=?][method=?]", item_precos_path, "post" do

      assert_select "input[name=?]", "item_preco[tabela_preco_id]"

      assert_select "input[name=?]", "item_preco[produto_id]"

      assert_select "input[name=?]", "item_preco[preco]"
    end
  end
end
