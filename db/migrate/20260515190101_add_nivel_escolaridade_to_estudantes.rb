class AddNivelEscolaridadeToEstudantes < ActiveRecord::Migration[8.1]
  def change
    add_column :estudantes, :nivel_escolaridade, :integer
  end
end
