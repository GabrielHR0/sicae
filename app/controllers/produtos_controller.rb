class ProdutosController < ApplicationController
  include DataTableable

  DEFAULT_LIMIT = 20
  PER_PAGE_OPTIONS = [10, 20, 50, 100].freeze
  SORTABLE_COLUMNS = %w[nome categoria estoque preco ativo].freeze
  SEARCHABLE_COLUMNS = %w[nome descricao categoria].freeze

  before_action :authenticate_user!
  before_action :set_produto, only: %i[show edit update destroy]
  # after_action :verify_authorized

  def index
    @pagy, @records = paginate_data_table(
      Produto.all,
      default_sort: :nome,
      sortable_columns: SORTABLE_COLUMNS,
      searchable_columns: SEARCHABLE_COLUMNS,
      default_limit: DEFAULT_LIMIT,
      per_page_options: PER_PAGE_OPTIONS
    ) do |scope|
      scope = scope.por_categoria(params[:categoria])
      scope = scope.where(ativo: active_filter) if params[:ativo].present?
      scope
    end
  end

  def show
    authorize @produto
  end

  def new
    @produto = Produto.new
    authorize @produto
  end

  def create
    @produto = Produto.new(produto_params)
    authorize @produto

    if @produto.save
      redirect_to @produto, notice: "Produto cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @produto
  end

  def update
    authorize @produto

    if @produto.update(produto_params)
      redirect_to @produto, notice: "Produto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @produto
    @produto.destroy
    redirect_to produtos_path, notice: "Produto removido com sucesso."
  end

  private

  def set_produto
    @produto = Produto.find(params[:id])
  end

  def produto_params
    params.require(:produto).permit(:nome, :descricao, :preco, :categoria, :estoque, :ativo)
  end

  def active_filter
    ActiveModel::Type::Boolean.new.cast(params[:ativo])
  end
end
