class ResponsaveisController < ApplicationController
  include DataTableable

  after_action :verify_authorized

  SORTABLE_COLUMNS = %w[nome relacao_parental estudantes_count].freeze
  SEARCHABLE_COLUMNS = %w[nome email cpf].freeze

  data_table default_sort: { nome: :asc },
             sortable_columns: SORTABLE_COLUMNS,
             searchable_columns: SEARCHABLE_COLUMNS,
             default_limit: 20,
             per_page_options: [10, 20, 50, 100]

  before_action :set_responsavel, only: %i[show edit update destroy]

  def index
    authorize Responsavel
    @pagy, @records = paginate_data_table(
      Responsavel
        .left_joins(user: :perfil)
        .select("responsaveis.*, perfis.nome AS nome, users.email AS email, (SELECT COUNT(*) FROM estudantes WHERE estudantes.responsavel_id = responsaveis.id) AS estudantes_count")
    ) do |scope|
      scope
    end
  end

  def show
    authorize @responsavel
    @estudantes = @responsavel.estudantes.order(:nome)
    @bloqueios = @responsavel.bloqueios.ativos.includes(:produto, :estudante).order(created_at: :desc)
    @reservas = @responsavel.reservas.includes(:produto, :estudante).order(data: :desc).limit(20)

    if turbo_frame_request?
      render partial: "responsaveis/edit_modal_content", locals: { responsavel: @responsavel }
    end
  end

  def new
    @responsavel = Responsavel.new
    authorize @responsavel

    if turbo_frame_request?
      render partial: "responsaveis/create_modal_content", locals: { responsavel: @responsavel }
    end
  end

  def create
    @responsavel = Responsavel.new
    authorize @responsavel

    ActiveRecord::Base.transaction do
      user = User.new(
        email: responsavel_params[:email],
        username: responsavel_params[:username],
        password: responsavel_params[:password],
        escola: current_user&.escola
      )
      user.save!

      perfil = user.build_perfil(
        nome: responsavel_params[:nome],
        cpf: responsavel_params[:cpf],
        telefone: responsavel_params[:telefone],
        data_nascimento: responsavel_params[:data_nascimento]
      )
      perfil.save!

      role = Role.find_by(nome: "responsavel")
      if role.nil?
        @responsavel.errors.add(:base, "Role 'responsavel' não encontrada no sistema. Contate o administrador.")
        raise ActiveRecord::RecordInvalid.new(@responsavel)
      end
      user.roles << role

      @responsavel.user = user
      @responsavel.relacao_parental = responsavel_params[:relacao_parental]
      @responsavel.save!
    end

    redirect_to responsaveis_path, notice: "Responsável cadastrado com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    assign_virtual_attrs
    record = e.record
    if record.is_a?(User) || record.is_a?(Perfil)
      record.errors.full_messages.each { |msg| @responsavel.errors.add(:base, msg) }
    end
    render :new, status: :unprocessable_entity
  rescue ActiveRecord::RecordNotSaved
    assign_virtual_attrs
    @responsavel.errors.add(:base, "Erro ao salvar. Verifique os dados e tente novamente.")
    render :new, status: :unprocessable_entity
  end

  def edit
    authorize @responsavel

    if turbo_frame_request?
      render partial: "responsaveis/edit_modal_content", locals: { responsavel: @responsavel }
    end
  end

  def update
    authorize @responsavel

    ActiveRecord::Base.transaction do
      user = @responsavel.user
      user.update!(email: responsavel_params[:email]) if responsavel_params[:email].present?

      if responsavel_params[:password].present?
        user.update!(password: responsavel_params[:password])
      end

      if user.perfil
        user.perfil.update!(
          nome: responsavel_params[:nome],
          cpf: responsavel_params[:cpf],
          telefone: responsavel_params[:telefone],
          data_nascimento: responsavel_params[:data_nascimento]
        )
      end

      @responsavel.update!(relacao_parental: responsavel_params[:relacao_parental])
    end

    redirect_to responsaveis_path, notice: "Responsável atualizado com sucesso."
  rescue ActiveRecord::RecordInvalid
    assign_virtual_attrs
    render :edit, status: :unprocessable_entity
  end

  def destroy
    authorize @responsavel
    @responsavel.destroy!
    redirect_to responsaveis_path, notice: "Responsável removido com sucesso."
  rescue ActiveRecord::InvalidForeignKey, ActiveRecord::DeleteRestrictionError
    redirect_to responsaveis_path, alert: "Não é possível remover: responsável possui vínculos ativos."
  end

  private

  def set_responsavel
    @responsavel = Responsavel.includes(user: :perfil).find(params[:id])
    populate_virtual_attrs_from_db
  end

  def populate_virtual_attrs_from_db
    perfil = @responsavel.user&.perfil
    @responsavel.nome = perfil&.nome
    @responsavel.email = @responsavel.user&.email
    @responsavel.username = @responsavel.user&.username
    @responsavel.cpf = perfil&.cpf
    @responsavel.telefone = perfil&.telefone
    @responsavel.data_nascimento = perfil&.data_nascimento
  end

  def responsavel_params
    params.require(:responsavel).permit(:nome, :email, :username, :password, :cpf, :telefone, :data_nascimento, :relacao_parental)
  end

  def assign_virtual_attrs
    p = responsavel_params
    @responsavel.nome = p[:nome]
    @responsavel.email = p[:email]
    @responsavel.username = p[:username]
    @responsavel.cpf = p[:cpf]
    @responsavel.telefone = p[:telefone]
    @responsavel.data_nascimento = p[:data_nascimento]
    @responsavel.relacao_parental = p[:relacao_parental]
  end

  def data_table_search_scope(scope, search_field, term)
    case search_field
    when "nome"
      [scope.where("perfis.nome ILIKE :term", term: "%#{term}%"), true]
    when "email"
      [scope.where("users.email ILIKE :term", term: "%#{term}%"), true]
    else
      [scope, false]
    end
  end
end
