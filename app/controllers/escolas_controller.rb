class EscolasController < ApplicationController
  before_action :set_escola, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only: %i[ new create ]
  skip_after_action :verify_authorized, only: %i[ new create ]

  def index
    authorize Escola
    @escolas = Escola.all
  end

  def show
    authorize @escola
  end

  def new
    @escola = Escola.new
  end

  def edit
    authorize @escola
  end

  def create
    @escola = Escola.new(escola_params)
    @escola.assign_attributes(
      ativo: true,
      cnpj: @escola.cnpj.presence || "00.000.000/0000-00",
      email: @escola.email.presence || "contato@#{@escola.nome.parameterize}.com.br",
      telefone: @escola.telefone.presence || "(00) 0000-0000"
    )

    if @escola.save
      current_user.update!(escola: @escola) if current_user
      redirect_to dashboard_path, notice: "Escola criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @escola
    if @escola.update(escola_params)
      redirect_to @escola, notice: "Escola atualizada.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @escola
    @escola.destroy!
    redirect_to escolas_path, notice: "Escola removida.", status: :see_other
  end

  private

  def set_escola
    @escola = Escola.find(params.expect(:id))
  end

  def escola_params
    params.expect(escola: [ :nome, :cnpj, :email, :telefone, :ativo, :metadata ])
  end
end
