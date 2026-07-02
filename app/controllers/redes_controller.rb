class RedesController < ApplicationController
  before_action :set_rede, only: %i[ show edit update destroy ]

  def index
    authorize Rede
    @redes = Rede.all
  end

  def show
    authorize @rede
  end

  def new
    @rede = Rede.new
    authorize @rede
  end

  def edit
    authorize @rede
  end

  def create
    @rede = Rede.new(rede_params)
    authorize @rede

    respond_to do |format|
      if @rede.save
        format.html { redirect_to @rede, notice: "Rede foi criada com sucesso." }
        format.json { render :show, status: :created, location: @rede }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rede.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize @rede
    respond_to do |format|
      if @rede.update(rede_params)
        format.html { redirect_to @rede, notice: "Rede foi atualizada.", status: :see_other }
        format.json { render :show, status: :ok, location: @rede }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rede.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @rede
    @rede.destroy!

    respond_to do |format|
      format.html { redirect_to redes_path, notice: "Rede foi removida.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_rede
    @rede = Rede.find(params.expect(:id))
  end

  def rede_params
    params.expect(rede: [ :nome, :slug, :descricao, :metadata, :ativo ])
  end
end
