class ProdutosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_produto, only: %i[show edit update destroy]
  after_action :verify_authorized

  include Pagy::Backend

  def index
    authorize Produto
    produtos = Produto.all
    produtos = produtos.por_categoria(params[:categoria])
    produtos = produtos.where(ativo: params[:ativo]) if params[:ativo].present?
    produtos = produtos.order(:nome)
    @pagy, @produtos = pagy(produtos, limit: 20)
  end

  def show
    authorize @produto
  end

  def new
    @produto = Produto.new
    authorize @produto
  end

  def create
    @produto = Produto.new(produto_params)
    authorize @produto

    if @produto.save
      redirect_to @produto, notice: "Produto cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @produto
  end

  def update
    authorize @produto

    if @produto.update(produto_params)
      redirect_to @produto, notice: "Produto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @produto
    @produto.destroy
    redirect_to produtos_path, notice: "Produto removido com sucesso."
  end

  private

  def set_produto
    @produto = Produto.find(params[:id])
  end

  def produto_params
    params.require(:produto).permit(:nome, :descricao, :preco, :categoria, :estoque, :ativo)
  end
end
