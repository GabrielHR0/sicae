class ReservasController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def create
    @responsavel = current_user.responsavel
    @estudante = @responsavel.estudantes.find(reserva_params[:estudante_id])
    @produto = Produto.find(reserva_params[:produto_id])

    @reserva = Reserva.new(reserva_params)
    @reserva.responsavel = @responsavel
    authorize @reserva

    if @reserva.save
      redirect_to cardapio_responsavel_path(estudante_id: @estudante.id),
                  notice: "Item reservado com sucesso."
    else
      redirect_to cardapio_responsavel_path(estudante_id: @estudante.id),
                  alert: @reserva.errors.full_messages.to_sentence
    end
  end

  def destroy
    @reserva = current_user.responsavel.reservas.find(params[:id])
    authorize @reserva

    estudante_id = @reserva.estudante_id
    @reserva.destroy

    redirect_to cardapio_responsavel_path(estudante_id: estudante_id),
                notice: "Reserva removida com sucesso."
  end

  private

  def reserva_params
    params.require(:reserva).permit(:estudante_id, :produto_id, :data)
  end
end
