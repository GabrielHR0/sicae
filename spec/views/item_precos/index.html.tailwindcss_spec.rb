require 'rails_helper'

RSpec.describe "item_precos/index", type: :view do
  before(:each) do
    assign(:item_precos, [
      ItemPreco.create!(
        tabela_preco: nil,
        produto: nil,
        preco: "9.99"
      ),
      ItemPreco.create!(
        tabela_preco: nil,
        produto: nil,
        preco: "9.99"
      )
    ])
  end

  it "renders a list of item_precos" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
  end
end
