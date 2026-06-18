class TabelaPrecosController < ApplicationController
  before_action :set_tabela_preco, only: %i[ show edit update destroy ]

  # GET /tabela_precos or /tabela_precos.json
  def index
    @tabela_precos = TabelaPreco.all
  end

  # GET /tabela_precos/1 or /tabela_precos/1.json
  def show
  end

  # GET /tabela_precos/new
  def new
    @tabela_preco = TabelaPreco.new
  end

  # GET /tabela_precos/1/edit
  def edit
  end

  # POST /tabela_precos or /tabela_precos.json
  def create
    @tabela_preco = TabelaPreco.new(tabela_preco_params)

    respond_to do |format|
      if @tabela_preco.save
        format.html { redirect_to @tabela_preco, notice: "Tabela preco was successfully created." }
        format.json { render :show, status: :created, location: @tabela_preco }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tabela_precos/1 or /tabela_precos/1.json
  def update
    respond_to do |format|
      if @tabela_preco.update(tabela_preco_params)
        format.html { redirect_to @tabela_preco, notice: "Tabela preco was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @tabela_preco }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tabela_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tabela_precos/1 or /tabela_precos/1.json
  def destroy
    @tabela_preco.destroy!

    respond_to do |format|
      format.html { redirect_to tabela_precos_path, notice: "Tabela preco was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tabela_preco
      @tabela_preco = TabelaPreco.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def tabela_preco_params
      params.expect(tabela_preco: [ :nome, :descricao, :tipo, :status, :inicioVigencia, :fimVigencia ])
    end
end
