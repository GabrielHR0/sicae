class VendasController < ApplicationController
  def new
  end

  def create
  end

  def produto_card
    @produto = Produto.find(params[:id])
    render partial: "vendas/produto_card", layout: false, locals: { produto: @produto }  
  end
end
