module DataTableable
  extend ActiveSupport::Concern

  private

  def paginate_data_table(scope, default_sort:, sortable_columns:, searchable_columns:, default_limit:, per_page_options:)
    scope = yield(scope) if block_given?
    scope = apply_data_table_search(scope, searchable_columns)
    scope = apply_data_table_sort(scope, default_sort, sortable_columns)

    pagy(:offset, scope, limit: data_table_per_page(default_limit, per_page_options))
  end

  def apply_data_table_search(scope, searchable_columns)
    return scope if data_table_search_term.blank?

    scope.where(
      "#{data_table_search_column(searchable_columns)} ILIKE :term",
      term: "%#{data_table_search_term}%"
    )
  end

  def apply_data_table_sort(scope, default_sort, sortable_columns)
    return scope.order(default_sort) unless params[:sort].in?(sortable_columns)

    direction = params[:direction] == "desc" ? :desc : :asc
    scope.order(params[:sort] => direction)
  end

  def data_table_search_term
    params[:q].to_s.strip.presence
  end

  def data_table_search_column(searchable_columns)
    return searchable_columns.first unless params[:search_field].in?(searchable_columns)

    params[:search_field]
  end

  def data_table_per_page(default_limit, per_page_options)
    limit = params[:limit].to_i
    per_page_options.include?(limit) ? limit : default_limit
  end
end