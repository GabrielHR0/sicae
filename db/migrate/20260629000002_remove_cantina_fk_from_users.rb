class RemoveCantinaFkFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :users, column: :cantina_id if foreign_key_exists?(:users, column: :cantina_id)
  end
end
