class EstudantesController < ApplicationController
  include DataTableable

  SORTABLE_COLUMNS = %w[nome matricula turma serie data_nascimento nivel_escolaridade].freeze
  SEARCHABLE_COLUMNS = %w[nome matricula responsavel_nome].freeze

  data_table default_sort: { nome: :asc },
             sortable_columns: SORTABLE_COLUMNS,
             searchable_columns: SEARCHABLE_COLUMNS,
             default_limit: 20,
             per_page_options: [10, 20, 50, 100]

  before_action :set_estudante, only: %i[show edit update destroy]

  def index
    @stats = {
      "total_count" => Estudante.count,
      "nivel_fundamental" => Estudante.where(nivel_escolaridade: 0).count,
      "nivel_medio" => Estudante.where(nivel_escolaridade: 1).count,
      "com_responsavel" => Estudante.where.not(responsavel_id: nil).count
    }
    @pagy, @records = paginate_data_table(Estudante.includes(responsavel: { user: :perfil }).references(responsavel: { user: :perfil })) do |scope|
      scope
    end
  end

  def show
    @bloqueios = @estudante.bloqueios.ativos.includes(:produto, :responsavel).order(created_at: :desc)
    @reservas = @estudante.reservas.includes(:produto, :responsavel).order(data: :desc).limit(20)

    if turbo_frame_request?
      render partial: "estudantes/edit_modal_content", locals: { estudante: @estudante }
    end
  end

  def new
    @estudante = Estudante.new
    @responsaveis = Responsavel.includes(user: :perfil).map { |r| [ r.user.perfil.nome, r.id ] }
    if turbo_frame_request?
      render partial: "estudantes/create_modal_content", locals: { estudante: @estudante, responsaveis: @responsaveis }
    end
  end

  def create
    @estudante = Estudante.new(estudante_params)
    @responsaveis = Responsavel.includes(user: :perfil).map { |r| [ r.user.perfil.nome, r.id ] }
    if @estudante.save
      redirect_to estudantes_path, notice: "Estudante cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @responsaveis = Responsavel.includes(user: :perfil).map { |r| [ r.user.perfil.nome, r.id ] }
  end

  def update
    @responsaveis = Responsavel.includes(user: :perfil).map { |r| [ r.user.perfil.nome, r.id ] }
    if @estudante.update(estudante_params)
      redirect_to estudantes_path, notice: "Estudante atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @estudante.destroy!
    redirect_to estudantes_path, notice: "Estudante removido com sucesso."
  end

  private

  def set_estudante
    @estudante = Estudante.includes(responsavel: { user: :perfil }).find(params[:id])
  end

  def estudante_params
    params.require(:estudante).permit(:nome, :matricula, :turma, :serie, :data_nascimento, :nivel_escolaridade, :responsavel_id)
  end

  def data_table_search_scope(scope, search_field, term)
    case search_field
    when "responsavel_nome"
      [scope.where("perfis.nome ILIKE :term", term: "%#{term}%"), true]
    else
      [scope, false]
    end
  end

  def active_filter
    ActiveModel::Type::Boolean.new.cast(params[:ativo])
  end
end


