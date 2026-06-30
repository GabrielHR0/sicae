class BloqueiosController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def new
    @responsavel = current_user.responsavel
    @estudante = @responsavel.estudantes.find(params[:estudante_id])
    @produto = Produto.find(params[:produto_id])
    @data = Date.parse(params[:data])

    @bloqueio = Bloqueio.new(estudante: @estudante, produto: @produto)
    authorize @bloqueio
  end

  def create
    @responsavel = current_user.responsavel
    @estudante = @responsavel.estudantes.find(bloqueio_params[:estudante_id])
    @produto = Produto.find(bloqueio_params[:produto_id])

    @bloqueio = Bloqueio.new(bloqueio_params)
    @bloqueio.responsavel = @responsavel
    authorize @bloqueio

    definir_data_fim_automatica

    if @bloqueio.save
      redirect_to cardapio_responsavel_path(estudante_id: @estudante.id),
                  notice: "Item bloqueado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @bloqueio = current_user.responsavel.bloqueios.find(params[:id])
    authorize @bloqueio

    estudante_id = @bloqueio.estudante_id
    @bloqueio.destroy

    redirect_to cardapio_responsavel_path(estudante_id: estudante_id),
                notice: "Bloqueio removido com sucesso."
  end

  private

  def bloqueio_params
    params.require(:bloqueio).permit(:estudante_id, :produto_id, :tipo_periodo, :data_inicio, :data_fim, :observacao)
  end

  # Calcula data_fim automaticamente conforme o tipo de período escolhido,
  # exceto quando for "personalizado" (o usuário já informou a data_fim)
  def definir_data_fim_automatica
    case @bloqueio.tipo_periodo
    when "apenas_hoje"
      @bloqueio.data_fim = @bloqueio.data_inicio
    when "ate_sexta"
      @bloqueio.data_fim = @bloqueio.data_inicio.end_of_week(:sunday) - 2.days
      
    when "indefinido"
      @bloqueio.data_fim = nil
    end
    
  end
end
