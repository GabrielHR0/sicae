class Cantina::CardapiosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cardapio, only: %i[show edit update destroy]
  after_action :verify_authorized


  def index
    authorize [ :cantina, Cardapio ]
    @pagy, @cardapios = pagy(Cardapio.order(data: :desc), limit: 20)
  end

  def new
    @cardapio = Cardapio.new
    authorize [ :cantina, @cardapio ]
  end

  def create
    @cardapio = Cardapio.new(cardapio_params)
    authorize [ :cantina, @cardapio ]

    if @cardapio.save
      redirect_to cantina_cardapio_path(@cardapio),
                  notice: "Cardápio cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    authorize [ :cantina, @cardapio ]
    @produtos_disponiveis = Produto.ativos.order(:nome)
    @produtos_do_cardapio = @cardapio.produtos
  end

  def edit
    authorize [ :cantina, @cardapio ]
  end

  def update
    authorize [ :cantina, @cardapio ]

    if @cardapio.update(cardapio_params)
      redirect_to cantina_cardapio_path(@cardapio),
                  notice: "Cardápio atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize [ :cantina, @cardapio ]
    @cardapio.destroy
    redirect_to cantina_cardapios_path,
                notice: "Cardápio removido com sucesso."
  end

  private

  def set_cardapio
    @cardapio = Cardapio.find(params[:id])
  end

  def cardapio_params
    params.require(:cardapio).permit(:data, :observacao, :ativo)
  end
end
