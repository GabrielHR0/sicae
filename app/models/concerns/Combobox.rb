module Combobox
  extend ActiveSupport::Concern

  included do
    class_attribute :combobox_config
  end

  class_methods do
    def combobox_for(record, search:, represent:)
      self.combobox_config = {
        model: record,
        search_fields: search,
        represent_fields: represent
      }
    end
  end

  def busca
    config = self.class.combobox_config
    query = params[:q]

    conditions = config[:search_fields].map {
      |field| "#{field} ILIKE :q"
    }.join(" OR ")

    results = config[:model]
      .where(conditions, q: "%#{query}%")
      .limit(10)

    render json: results.map { |item|
      config[:represent_fields].index_with { |field| item.send(field) }
    }
  end
end
