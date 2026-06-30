class Pagamento < ApplicationRecord
  belongs_to :lancamento, polymorphic: true
  belongs_to :forma_pagamento
end
