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

ActiveRecord::Schema[8.1].define(version: 2026_06_18_014031) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bloqueios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_fim"
    t.date "data_inicio", null: false
    t.bigint "estudante_id", null: false
    t.text "observacao"
    t.bigint "produto_id", null: false
    t.bigint "responsavel_id", null: false
    t.integer "tipo_periodo", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["estudante_id", "produto_id"], name: "index_bloqueios_on_estudante_id_and_produto_id"
    t.index ["estudante_id"], name: "index_bloqueios_on_estudante_id"
    t.index ["produto_id"], name: "index_bloqueios_on_produto_id"
    t.index ["responsavel_id"], name: "index_bloqueios_on_responsavel_id"
  end

  create_table "cardapio_produtos", force: :cascade do |t|
    t.bigint "cardapio_id", null: false
    t.datetime "created_at", null: false
    t.bigint "produto_id", null: false
    t.datetime "updated_at", null: false
    t.index ["cardapio_id", "produto_id"], name: "index_cardapio_produtos_on_cardapio_id_and_produto_id", unique: true
    t.index ["cardapio_id"], name: "index_cardapio_produtos_on_cardapio_id"
    t.index ["produto_id"], name: "index_cardapio_produtos_on_produto_id"
  end

  create_table "cardapios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.date "data", null: false
    t.text "observacao"
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_cardapios_on_ativo"
    t.index ["data"], name: "index_cardapios_on_data", unique: true
  end

  create_table "categorias", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_categorias_on_ativo"
    t.index ["nome"], name: "index_categorias_on_nome", unique: true
  end

  create_table "escolas", force: :cascade do |t|
    t.boolean "ativo", null: false
    t.string "cnpj", null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "nome", null: false
    t.bigint "rede_id"
    t.string "schema_name", null: false
    t.string "slug", null: false
    t.string "telefone", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_escolas_on_cnpj", unique: true
    t.index ["email"], name: "index_escolas_on_email", unique: true
    t.index ["rede_id"], name: "index_escolas_on_rede_id"
    t.index ["schema_name"], name: "index_escolas_on_schema_name", unique: true
    t.index ["slug"], name: "index_escolas_on_slug", unique: true
  end

  create_table "estudantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_nascimento"
    t.string "matricula"
    t.integer "nivel_escolaridade"
    t.string "nome", default: "", null: false
    t.bigint "responsavel_id", null: false
    t.integer "serie"
    t.string "turma"
    t.datetime "updated_at", null: false
    t.index ["responsavel_id"], name: "index_estudantes_on_responsavel_id"
  end

  create_table "item_precos", primary_key: ["tabela_preco_id", "produto_id"], force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigserial "id", null: false
    t.decimal "preco", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "produto_id", null: false
    t.bigint "tabela_preco_id", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_item_precos_on_produto_id"
    t.index ["tabela_preco_id"], name: "index_item_precos_on_tabela_preco_id"
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

  create_table "produtos", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.bigint "categoria_id", null: false
    t.datetime "created_at", null: false
    t.text "descricao"
    t.integer "estoque", default: 0, null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["ativo"], name: "index_produtos_on_ativo"
    t.index ["categoria_id"], name: "index_produtos_on_categoria_id"
    t.index ["nome"], name: "index_produtos_on_nome"
  end

  create_table "redes", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.text "descricao"
    t.jsonb "metadata", default: {}, null: false
    t.string "nome", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_redes_on_slug", unique: true
  end

  create_table "reservas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data", null: false
    t.bigint "estudante_id", null: false
    t.bigint "produto_id", null: false
    t.bigint "responsavel_id", null: false
    t.datetime "updated_at", null: false
    t.index ["estudante_id", "produto_id", "data"], name: "index_reservas_on_estudante_id_and_produto_id_and_data", unique: true
    t.index ["estudante_id"], name: "index_reservas_on_estudante_id"
    t.index ["produto_id"], name: "index_reservas_on_produto_id"
    t.index ["responsavel_id"], name: "index_reservas_on_responsavel_id"
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

  create_table "tabela_precos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao"
    t.datetime "fimVigencia"
    t.datetime "inicioVigencia"
    t.string "nome", null: false
    t.integer "status", default: 0
    t.integer "tipo", default: 0
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.bigint "escola_id"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["escola_id"], name: "index_users_on_escola_id"
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

  add_foreign_key "bloqueios", "estudantes"
  add_foreign_key "bloqueios", "produtos"
  add_foreign_key "bloqueios", "responsaveis"
  add_foreign_key "cardapio_produtos", "cardapios"
  add_foreign_key "cardapio_produtos", "produtos"
  add_foreign_key "escolas", "redes"
  add_foreign_key "estudantes", "responsaveis"
  add_foreign_key "item_precos", "produtos"
  add_foreign_key "item_precos", "tabela_precos"
  add_foreign_key "perfis", "users"
  add_foreign_key "produtos", "categorias"
  add_foreign_key "reservas", "estudantes"
  add_foreign_key "reservas", "produtos"
  add_foreign_key "reservas", "responsaveis"
  add_foreign_key "responsaveis", "users"
  add_foreign_key "roles_permissions", "permissions"
  add_foreign_key "roles_permissions", "roles"
  add_foreign_key "users", "escolas"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end
