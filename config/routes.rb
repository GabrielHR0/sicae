Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all

<<<<<<< Updated upstream
  resources :produtos
=======
  get "vendas", to: "vendas#new"
  get "vendas/produtos/:id/card", to: "vendas#produto_card"
  get "vendas/estudantes/:id/card", to: "vendas#estudante_card"
  post "vendas", to: "vendas#create"
  patch "vendas/:id/cancelar", to: "vendas#cancelar"
  resources :produtos do
    get :busca, on: :collection
  end
>>>>>>> Stashed changes
  resources :categorias
  resources :tabela_precos

  scope :responsavel do
    get "cardapio", to: "cardapios#index", as: :cardapio_responsavel
    get "cardapio/produto/:produto_id", to: "cardapios#show", as: :cardapio_produto_responsavel
  end

  resources :redes
  resources :escolas
  # Defines the root path route ("/")
  root "landing#index"
  get "dashboard", to: "home#index"
end
