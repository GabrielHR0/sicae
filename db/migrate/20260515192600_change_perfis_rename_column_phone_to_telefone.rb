class ChangePerfisRenameColumnPhoneToTelefone < ActiveRecord::Migration[8.1]
  def change
    rename_column :perfis, :phone, :telefone
  end
end
