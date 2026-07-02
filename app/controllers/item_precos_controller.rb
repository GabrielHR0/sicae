class ItemPrecosController < ApplicationController
  include DataTableable

  SORTABLE_COLUMNS = %w[preco].freeze
  SEARCHABLE_COLUMNS = %w[produto].freeze

  data_table default_sort: { preco: :asc },
             sortable_columns: SORTABLE_COLUMNS,
             searchable_columns: SEARCHABLE_COLUMNS,
             default_limit: 20,
             per_page_options: [ 10, 20, 50, 100 ]

  before_action :set_tabela_preco
  before_action :set_item_preco, only: %i[edit update destroy]

  def index
    authorize ItemPreco
    @pagy, @records = paginate_data_table(@tabela_preco.item_precos.includes(:produto))
  end

  def new
    @item_preco = @tabela_preco.item_precos.build
    authorize @item_preco

    if turbo_frame_request?
      render partial: "item_precos/create_modal_content",
             locals: { item_preco: @item_preco, tabela_preco: @tabela_preco, produtos: Produto.ativos.order(:nome) }
    end
  end

  def create
    @item_preco = @tabela_preco.item_precos.build(item_preco_params)
    authorize @item_preco

    if @item_preco.save
      redirect_to tabela_preco_item_precos_path(@tabela_preco), notice: "Item cadastrado com sucesso."
    else
      render partial: "item_precos/create_modal_content",
             locals: { item_preco: @item_preco, tabela_preco: @tabela_preco, produtos: Produto.ativos.order(:nome) },
             status: :unprocessable_entity
    end
  end

  def edit
    authorize @item_preco
    if turbo_frame_request?
      render partial: "item_precos/edit_modal_content",
             locals: { item_preco: @item_preco, tabela_preco: @tabela_preco, produtos: Produto.ativos.order(:nome) }
    end
  end

  def update
    authorize @item_preco
    if @item_preco.update(item_preco_params)
      redirect_to tabela_preco_item_precos_path(@tabela_preco), notice: "Item atualizado com sucesso."
    else
      render partial: "item_precos/edit_modal_content",
             locals: { item_preco: @item_preco, tabela_preco: @tabela_preco, produtos: Produto.ativos.order(:nome) },
             status: :unprocessable_entity
    end
  end

  def destroy
    authorize @item_preco
    @item_preco.destroy!
    redirect_to tabela_preco_item_precos_path(@tabela_preco), notice: "Item removido com sucesso."
  end

  private

  def set_tabela_preco
    @tabela_preco = TabelaPreco.find(params[:tabela_preco_id])
  end

  def set_item_preco
    @item_preco = @tabela_preco.item_precos.find(params[:id])
  end

  def item_preco_params
    params.require(:item_preco).permit(:produto_id, :preco)
  end

  def data_table_search_scope(scope, search_field, term)
    if search_field == "produto"
      [ scope.joins(:produto).where("produtos.nome ILIKE :term", term: "%#{term}%"), true ]
    else
      [ scope, false ]
    end
  end
end
