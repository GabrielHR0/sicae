class TabelaPrecosController < ApplicationController
  before_action :set_tabela_preco, only: %i[ show edit update destroy ]

  def index
    authorize TabelaPreco
    @pagy, @tabela_precos = pagy(TabelaPreco.all, limit: 8)
  end

  def show
    authorize @tabela_preco
    if turbo_frame_request? && params[:modal] == "edit"
      render partial: "tabela_precos/edit_modal_content", locals: { tabela_preco: @tabela_preco }
    end
  end

  def new
    @tabela_preco = TabelaPreco.new
    authorize @tabela_preco
    render partial: "tabela_precos/create_modal_content", locals: { tabela_preco: @tabela_preco }
  end

  def edit
    authorize @tabela_preco
    render partial: "tabela_precos/edit_modal_content", locals: { tabela_preco: @tabela_preco }
  end

  def create
    @tabela_preco = TabelaPreco.new(tabela_preco_params.except(:ativo))
    authorize @tabela_preco
    @tabela_preco.status = params.dig(:tabela_preco, :ativo) == "1" ? :ativo : :rascunho

    if @tabela_preco.save
      redirect_to tabela_precos_path, notice: "Tabela cadastrada com sucesso."
    else
      render partial: "tabela_precos/create_modal_content",
             locals: { tabela_preco: @tabela_preco },
             status: :unprocessable_entity
    end
  end

  def update
    authorize @tabela_preco
    if @tabela_preco.base?
      redirect_to tabela_precos_path, alert: "Tabelas base não podem ser editadas."
      return
    end

    @tabela_preco.assign_attributes(tabela_preco_params.except(:ativo))

    if params.dig(:tabela_preco, :ativo) == "1"
      @tabela_preco.status = :ativo
    elsif params.dig(:tabela_preco, :ativo) == "0"
      @tabela_preco.status = :inativo
    end

    if @tabela_preco.save
      redirect_to tabela_precos_path, notice: "Tabela atualizada com sucesso."
    else
      render partial: "tabela_precos/edit_modal_content",
             locals: { tabela_preco: @tabela_preco },
             status: :unprocessable_entity
    end
  end

  def destroy
    authorize @tabela_preco
    if @tabela_preco.base?
      redirect_to tabela_precos_path, alert: "Tabelas base não podem ser removidas.", status: :see_other
      return
    end

    @tabela_preco.destroy!
    redirect_to tabela_precos_path, notice: "Tabela removida com sucesso.", status: :see_other
  end

  private

  def set_tabela_preco
    @tabela_preco = TabelaPreco.find(params.expect(:id))
  end

  def tabela_preco_params
    params.expect(tabela_preco: [ :nome, :descricao, :tipo, :inicioVigencia, :fimVigencia, :ativo ])
  end
end
