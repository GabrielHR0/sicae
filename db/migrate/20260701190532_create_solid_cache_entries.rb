class CreateSolidCacheEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :solid_cache_entrys do |t|
      t.binary :key, null: false
      t.binary :value, null: false
      t.bigint :byte_size, null: false
      t.string :key_hash, null: false
      t.datetime :created_at, null: false

      t.index [:key_hash, :byte_size], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
      t.index [:key_hash], name: "index_solid_cache_entries_on_key_hash", unique: true
      t.index [:byte_size], name: "index_solid_cache_entries_on_byte_size"
    end
  end
end
