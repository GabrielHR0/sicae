class ItemLancamento < ApplicationRecord
  belongs_to :lancamento, optional: true
  belongs_to :produto
end
