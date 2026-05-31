require 'rails_helper'

RSpec.describe "redes/index", type: :view do
  before(:each) do
    assign(:redes, [
      Rede.create!(
        nome: "Nome",
        slug: "Slug",
        descricao: "MyText",
        metadata: "",
        ativo: false
      ),
      Rede.create!(
        nome: "Nome",
        slug: "Slug",
        descricao: "MyText",
        metadata: "",
        ativo: false
      )
    ])
  end

  it "renders a list of redes" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Nome".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Slug".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
