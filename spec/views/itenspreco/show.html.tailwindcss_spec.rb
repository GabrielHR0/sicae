require 'rails_helper'

RSpec.describe "item_precos/show", type: :view do
  before(:each) do
    assign(:item_preco, ItemPreco.create!(
      tabela_preco: nil,
      produto: nil,
      preco: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
  end
end
