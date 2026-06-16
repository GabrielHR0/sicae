class ItensprecoController < ApplicationController
  before_action :set_item_preco, only: %i[ show edit update destroy ]

  # GET /item_precos or /item_precos.json
  def index
    @item_precos = ItemPreco.all
  end

  # GET /item_precos/1 or /item_precos/1.json
  def show
  end

  # GET /item_precos/new
  def new
    @item_preco = ItemPreco.new
  end

  # GET /item_precos/1/edit
  def edit
  end

  # POST /item_precos or /item_precos.json
  def create
    @item_preco = ItemPreco.new(item_preco_params)

    respond_to do |format|
      if @item_preco.save
        format.html { redirect_to @item_preco, notice: "Item preco was successfully created." }
        format.json { render :show, status: :created, location: @item_preco }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /item_precos/1 or /item_precos/1.json
  def update
    respond_to do |format|
      if @item_preco.update(item_preco_params)
        format.html { redirect_to @item_preco, notice: "Item preco was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @item_preco }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item_preco.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_precos/1 or /item_precos/1.json
  def destroy
    @item_preco.destroy!

    respond_to do |format|
      format.html { redirect_to item_precos_path, notice: "Item preco was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_preco
      @item_preco = ItemPreco.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_preco_params
      params.expect(item_preco: [ :tabela_preco_id, :produto_id, :preco ])
    end
end
