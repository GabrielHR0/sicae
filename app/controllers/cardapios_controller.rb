class CardapiosController < ApplicationController
    def index
    authorize :cardapio, :index?

    @responsavel = current_user.responsavel
    @estudantes = @responsavel.estudantes

    # Estudante selecionado (primeiro por padrão)
    @estudante = if params[:estudante_id].present?
      @estudantes.find(params[:estudante_id])
    else
      @estudantes.first
    end

    # Semana selecionada (semana atual por padrão)
    @data_inicio = if params[:data_inicio].present?
      Date.parse(params[:data_inicio])
    else
      Date.today.beginning_of_week
    end

    @data_fim = @data_inicio + 4.days

    # Dias da semana com seus cardápios
    @dias = (0..4).map do |i|
      data = @data_inicio + i.days
      cardapio = Cardapio.ativos.find_by(data: data)
      { data: data, cardapio: cardapio }
    end

    # Dia selecionado (hoje por padrão)
    @data_selecionada = if params[:data].present?
      Date.parse(params[:data])
    else
      Date.today
    end

    @cardapio_do_dia = Cardapio.ativos.find_by(data: @data_selecionada)

    if @cardapio_do_dia
      # Busca bloqueios ativos do estudante para cruzar com os produtos
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
end
