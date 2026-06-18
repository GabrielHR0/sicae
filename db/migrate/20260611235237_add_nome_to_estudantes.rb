class AddNomeToEstudantes < ActiveRecord::Migration[8.1]
  def change
    add_column :estudantes, :nome, :string, null: false, default: ""
  end
end
