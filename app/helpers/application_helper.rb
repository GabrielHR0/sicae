module ApplicationHelper
  # Pagy frontend helpers intentionally not included here.

  def pagy_page_items(pagy, window: 2)
    return [] if pagy.blank? || pagy.pages <= 1

    pages = [1]
    from_page = [pagy.page - window, 2].max
    to_page = [pagy.page + window, pagy.pages - 1].min

    pages << :gap if from_page > 2
    pages.concat((from_page..to_page).to_a)
    pages << :gap if to_page < pagy.pages - 1
    pages << pagy.pages

    pages.uniq
  end
end