class AddReferencesAlunoToCompra < ActiveRecord::Migration[8.1]
  def change
    add_reference :compras, :estudante
  end
end
