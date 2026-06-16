class EscolasController < ApplicationController
  before_action :set_escola, only: %i[ show edit update destroy ]

  # GET /escolas or /escolas.json
  def index
    @escolas = Escola.all
  end

  # GET /escolas/1 or /escolas/1.json
  def show
  end

  # GET /escolas/new
  def new
    @escola = Escola.new
  end

  # GET /escolas/1/edit
  def edit
  end

  # POST /escolas or /escolas.json
  def create
    @escola = Escola.new(escola_params)

    respond_to do |format|
      if @escola.save
        format.html { redirect_to @escola, notice: "Escola was successfully created." }
        format.json { render :show, status: :created, location: @escola }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @escola.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /escolas/1 or /escolas/1.json
  def update
    respond_to do |format|
      if @escola.update(escola_params)
        format.html { redirect_to @escola, notice: "Escola was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @escola }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @escola.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /escolas/1 or /escolas/1.json
  def destroy
    @escola.destroy!

    respond_to do |format|
      format.html { redirect_to escolas_path, notice: "Escola was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_escola
      @escola = Escola.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def escola_params
      params.expect(escola: [ :nome, :slug, :schema_name, :cnpj, :email, :telefone, :ativo, :metadata ])
    end
end
