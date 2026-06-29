# app/controllers/cantina/cardapio_produtos_controller.rb
class Cantina::CardapioProdutosController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    @cardapio = Cardapio.find(params[:cardapio_id])
    @cardapio_produto = @cardapio.cardapio_produtos.new(produto_id: params[:produto_id])
    authorize [ :cantina, @cardapio_produto ]

    if @cardapio_produto.save
      redirect_to cantina_cardapio_path(@cardapio),
                  notice: "Produto adicionado ao cardápio."
    else
      redirect_to cantina_cardapio_path(@cardapio),
                  alert: "Produto já está neste cardápio."
    end
  end

  def destroy
    @cardapio = Cardapio.find(params[:cardapio_id])
    @cardapio_produto = @cardapio.cardapio_produtos.find(params[:id])
    authorize [ :cantina, @cardapio_produto ]

    @cardapio_produto.destroy
    redirect_to cantina_cardapio_path(@cardapio),
                notice: "Produto removido do cardápio."
  end
end
