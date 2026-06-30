class AddRelacaoParentalOutroToResponsaveis < ActiveRecord::Migration[8.1]
  def change
    add_column :responsaveis, :relacao_parental_outro, :string
  end
end
