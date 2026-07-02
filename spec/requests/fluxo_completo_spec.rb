require "rails_helper"

def with_schema(escola)
  old = ActiveRecord::Base.connection.schema_search_path
  path = "#{escola.schema_name},public"
  ActiveRecord::Base.connection.schema_search_path = path
  yield
ensure
  ActiveRecord::Base.connection.schema_search_path = old
end

RSpec.describe "Fluxo completo", type: :request do
  it "cria escola, categorias, produtos, estudantes, responsaveis e venda" do
    Role.find_or_create_by!(nome: "admin") { |r| r.descricao = "Administrador" }
    Role.find_or_create_by!(nome: "responsavel") { |r| r.descricao = "Responsavel" }
    post user_registration_path, params: { user: { username: "admin", email: "admin@e.com", password: "123456", password_confirmation: "123456", perfil_attributes: { nome: "Admin", cpf: "12345678901", telefone: "11999999999", data_nascimento: "01/01/2000" } } }
    follow_redirect!
    post escolas_path, params: { escola: { nome: "Escola" } }
    follow_redirect!
    escola = Escola.last; slug = escola.slug
    post "/#{slug}/categorias", params: { categoria: { nome: "Lanches" } }
    cat_id = response.location.match(/\/categorias\/(\d+)/)[1].to_i
    post "/#{slug}/produtos", params: { produto: { nome: "Sanduiche", preco: "10.00", categoria_id: cat_id, estoque: 50 } }
    prod_id = with_schema(escola) { Produto.last.id }
    post "/#{slug}/estudantes", params: { estudante: { nome: "Joao", matricula: "M1", turma: "5A", serie: 5, data_nascimento: "2010-05-15", nivel_escolaridade: 0 } }
    est_id = Estudante.last.id
    post "/#{slug}/responsaveis", params: { responsavel: { nome: "Maria", email: "m@r.com", username: "maria_r", password: "123456", cpf: "98765432100", telefone: "11977777777", data_nascimento: "1980-01-01", relacao_parental: "mae" } }
    with_schema(escola) do
      CantinaConfig.create!(nome: "Cantina")
      User.last.update!(cantina: CantinaConfig.last)
    end
    post "/#{slug}/vendas", params: { estudante_id: est_id, itens: [{ produto_id: prod_id, quantidade: 1, preco: 10.0, subtotal: 10.0 }], pagamento: { forma: "Dinheiro", valor_recebido: 10.0, troco: 0.0 } }, as: :json
    expect(response).to have_http_status(:created)
  end
end
