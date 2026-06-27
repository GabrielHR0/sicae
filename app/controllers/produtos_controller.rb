class ProdutosController < ApplicationController
  include DataTableable
  include Combobox

  combobox_for Produto.ativos, search: [ :nome, :codigo ], represent: [ :id, :nome, :preco, :codigo ]

  SORTABLE_COLUMNS = %w[nome codigo categoria estoque preco ativo].freeze
  SEARCHABLE_COLUMNS = %w[nome codigo descricao categoria].freeze

  data_table default_sort: :nome,
             sortable_columns: SORTABLE_COLUMNS,
             searchable_columns: SEARCHABLE_COLUMNS,
             default_limit: 20,
             per_page_options: [ 10, 20, 50, 100 ]

  before_action :set_produto, only: %i[show edit update destroy]
  # after_action :verify_authorized

  def index
    @stats = Produto.stats

    @pagy, @records = paginate_data_table(Produto.includes(:categoria)) do |scope|
      scope = scope.por_nome_categoria(params[:categoria])
      scope = scope.where(ativo: active_filter) if params[:ativo].present?
      scope
    end
  end

  def show
    if turbo_frame_request?
      case params[:modal]
      when "view"
        render partial: "produtos/show_modal_content", locals: { produto: @produto }
      when "edit"
        @categorias = Categoria.order(:nome)
        render partial: "produtos/edit_modal_content", locals: { produto: @produto, categorias: @categorias }
      end

      nil
    end
  end

  def new
    @produto = Produto.new
    @categorias = Categoria.order(:nome)

    if turbo_frame_request?
      render partial: "produtos/create_modal_content", locals: { produto: @produto, categorias: @categorias }
    end
  end

  def create
    @produto = Produto.new(produto_params)
    @categorias = Categoria.order(:nome)

    if @produto.save
      redirect_to produtos_path, notice: "Produto cadastrado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categorias = Categoria.order(:nome)
  end

  def update
    @categorias = Categoria.order(:nome)

    if @produto.update(produto_params)
      redirect_to produtos_path, notice: "Produto atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @produto.destroy
    redirect_to produtos_path, notice: "Produto removido com sucesso."
  end

  private

  def data_table_search_scope(scope, search_field, term)
    return [ scope.por_nome_categoria(term), true ] if search_field == "categoria"

    [ scope, false ]
  end

  def set_produto
    @produto = Produto.includes(:categoria).find(params[:id])
  end

  def produto_params
    params.require(:produto).permit(:nome, :codigo, :descricao, :preco, :categoria_id, :estoque, :ativo)
  end

  def active_filter
    ActiveModel::Type::Boolean.new.cast(params[:ativo])
  end
end
