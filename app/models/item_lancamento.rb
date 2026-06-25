class ItemLancamento < ApplicationRecord
  belongs_to :lancamento
  belongs_to :produto
end
