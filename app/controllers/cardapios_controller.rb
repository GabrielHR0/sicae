class CardapiosController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_escola!
  after_action :verify_authorized

  def index
    authorize :cardapio, :index?

    @responsavel = current_user.responsavel
    @estudantes = @responsavel.estudantes

    @estudante = if params[:estudante_id].present?
      @estudantes.find(params[:estudante_id])
    else
      @estudantes.first
    end

    @data_inicio = if params[:data_inicio].present?
      Date.parse(params[:data_inicio])
    else
      Date.today.beginning_of_week
    end

    # Regra de vigência — não permite navegar fora do mês atual
    @data_inicio = @data_inicio.clamp(
      Date.today.beginning_of_month,
      Date.today.end_of_month
    )

    @data_fim = @data_inicio + 4.days

    @dias = (0..4).map do |i|
      data = @data_inicio + i.days
      cardapio = Cardapio.ativos.find_by(data: data)
      { data: data, cardapio: cardapio }
    end

    @data_selecionada = if params[:data].present?
      Date.parse(params[:data])
    else
      Date.today
    end

    # Regra de vigência — data selecionada deve ser do mês atual
    @data_selecionada = @data_selecionada.clamp(
      Date.today.beginning_of_month,
      Date.today.end_of_month
    )

    @cardapio_do_dia = Cardapio.ativos.find_by(data: @data_selecionada)

    if @cardapio_do_dia
      bloqueios_ativos = Bloqueio.ativos
                                 .para_estudante(@estudante.id)
                                 .pluck(:produto_id)

      @produtos_com_status = @cardapio_do_dia.produtos.map do |produto|
        {
          produto: produto,
          bloqueado: bloqueios_ativos.include?(produto.id)
        }
      end
    end
  end

  def show
    authorize :cardapio, :show?

    @responsavel = current_user.responsavel
    @estudantes = @responsavel.estudantes
    @estudante = if params[:estudante_id].present?
      @estudantes.find(params[:estudante_id])
    else
      @estudantes.first
    end

    @data = Date.parse(params[:data])
    @produto = Produto.find(params[:produto_id])

    bloqueio = Bloqueio.ativos
                       .para_estudante(@estudante.id)
                       .para_produto(@produto.id)
                       .first

    @bloqueado = bloqueio.present?
    @reserva = Reserva.para_estudante(@estudante.id)
                      .para_data(@data)
                      .find_by(produto_id: @produto.id)
    @reservado = @reserva.present?
  end

  private

  # Regra de escola — garante que o responsável pertence à escola atual
  def verificar_escola!
    return if Current.escola.nil?

    unless current_user.escola_id == Current.escola.id
      flash[:alert] = "Você não tem acesso ao cardápio desta escola."
      redirect_to root_path
    end
  end
end
