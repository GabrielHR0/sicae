module DataTableable
  extend ActiveSupport::Concern

  included do
    class_attribute :data_table_config, default: {}
  end

  class_methods do
    def data_table(default_sort:, sortable_columns:, searchable_columns:, default_limit: 20, per_page_options: [10, 20, 50, 100])
      self.data_table_config = {
        default_sort: default_sort,
        sortable_columns: sortable_columns,
        searchable_columns: searchable_columns,
        default_limit: default_limit,
        per_page_options: per_page_options
      }
    end
  end

  private

  def paginate_data_table(scope)
    config = self.class.data_table_config

    scope = yield(scope) if block_given?
    scope = apply_data_table_search(scope, config[:searchable_columns])
    scope = apply_data_table_sort(scope, config[:default_sort], config[:sortable_columns])

    pagy(:offset, scope, limit: data_table_per_page(config[:default_limit], config[:per_page_options]))
  end

  def apply_data_table_search(scope, searchable_columns)
    term = data_table_search_term
    return scope if term.blank?

    search_field = data_table_search_column(searchable_columns)

    scope, handled = data_table_search_scope(scope, search_field, term)
    return scope if handled

    scope.where(
      "#{search_field} ILIKE :term",
      term: "%#{term}%"
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

  def data_table_search_scope(scope, _search_field, _term)
    [scope, false]
  end
end