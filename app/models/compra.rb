class Compra < ApplicationRecord
  has_secure_token
  belongs_to :cantina
  
  private
end