class BloqueiosController < ApplicationController
  def new
    @bloqueio = Bloqueio.new(estudante_id: params[:estudante_id])
    authorize @bloqueio
  end

  def create
    @bloqueio = Bloqueio.new(bloqueio_params)
    @bloqueio.responsavel = current_user.responsavel
    authorize @bloqueio

    if @bloqueio.save
      redirect_to estudante_path(@bloqueio.estudante), notice: "Produto bloqueado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @bloqueio = Bloqueio.find(params[:id])
    authorize @bloqueio
    @bloqueio.desativar!
    redirect_to estudante_path(@bloqueio.estudante), notice: "Bloqueio removido com sucesso."
  end

  private

  def bloqueio_params
    params.require(:bloqueio).permit(:estudante_id, :produto_id, :motivo)
  end
end
