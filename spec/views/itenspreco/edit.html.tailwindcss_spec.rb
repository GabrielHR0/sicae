require 'rails_helper'

RSpec.describe "item_precos/edit", type: :view do
  let(:item_preco) {
    ItemPreco.create!(
      tabela_preco: nil,
      produto: nil,
      preco: "9.99"
    )
  }

  before(:each) do
    assign(:item_preco, item_preco)
  end

  it "renders the edit item_preco form" do
    render

    assert_select "form[action=?][method=?]", item_preco_path(item_preco), "post" do

      assert_select "input[name=?]", "item_preco[tabela_preco_id]"

      assert_select "input[name=?]", "item_preco[produto_id]"

      assert_select "input[name=?]", "item_preco[preco]"
    end
  end
end
