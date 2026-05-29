class CategoriasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_categoria, only: %i[show edit update destroy]
  after_action :verify_authorized

  include Pagy::Backend

  def index
    authorize Categoria
    @pagy, @categorias = pagy(Categoria.order(:nome), limit: 20)
  end

  def show
    authorize @categoria
  end

  def new
    @categoria = Categoria.new
    authorize @categoria
  end

  def create
    @categoria = Categoria.new(categoria_params)
    authorize @categoria

    if @categoria.save
      redirect_to @categoria, notice: "Categoria cadastrada com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @categoria
  end

  def update
    authorize @categoria

    if @categoria.update(categoria_params)
      redirect_to @categoria, notice: "Categoria atualizada com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @categoria
    @categoria.destroy
    redirect_to categorias_path, notice: "Categoria removida com sucesso."
  end

  private

  def set_categoria
    @categoria = Categoria.find(params[:id])
  end

  def categoria_params
    params.require(:categoria).permit(:nome, :descricao, :ativo)
  end
end
