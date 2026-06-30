class MakeResponsavelNullableInEstudantes < ActiveRecord::Migration[8.1]
  def change
    change_column_null :estudantes, :responsavel_id, true
  end
end
