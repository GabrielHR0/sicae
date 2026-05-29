# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_26_232149) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "estudantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_nascimento"
    t.string "matricula"
    t.integer "nivel_escolaridade"
    t.bigint "responsavel_id", null: false
    t.integer "serie"
    t.string "turma"
    t.datetime "updated_at", null: false
    t.index ["responsavel_id"], name: "index_estudantes_on_responsavel_id"
  end

  create_table "perfis", force: :cascade do |t|
    t.string "cpf"
    t.datetime "created_at", null: false
    t.date "data_nascimento"
    t.string "nome"
    t.string "telefone"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_perfis_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "acao"
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "nome"
    t.string "recurso"
    t.datetime "updated_at", null: false
    t.index ["acao", "recurso"], name: "index_permissions_on_acao_and_recurso", unique: true
    t.index ["nome"], name: "index_permissions_on_nome", unique: true
  end

  create_table "responsaveis", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "relacao_parental"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_responsaveis_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "nome"
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_roles_on_nome", unique: true
  end

  create_table "roles_permissions", id: false, force: :cascade do |t|
    t.bigint "permission_id", null: false
    t.bigint "role_id", null: false
    t.index ["permission_id"], name: "index_roles_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_roles_permissions_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_roles_permissions_on_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "user_id", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "estudantes", "responsaveis"
  add_foreign_key "perfis", "users"
  add_foreign_key "responsaveis", "users"
  add_foreign_key "roles_permissions", "permissions"
  add_foreign_key "roles_permissions", "roles"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end
