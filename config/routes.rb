Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all

  get "vendas", to: "vendas#new"
  get "vendas/produtos/:id/card", to: "vendas#produto_card"
  get "vendas/estudantes/:id/card", to: "vendas#estudante_card"
  post "vendas", to: "vendas#create"
  patch "vendas/:id/cancelar", to: "vendas#cancelar"

  resources :produtos do
    get :busca, on: :collection
  end
  resources :categorias
  resources :responsaveis
  resources :estudantes do
    get :busca, on: :collection
  end
  resources :tabela_precos do
    resources :item_precos
  end

  scope :responsavel do
    get "cardapio", to: "cardapios#index", as: :cardapio_responsavel
    get "cardapio/produto/:produto_id", to: "cardapios#show", as: :cardapio_produto_responsavel

    resources :bloqueios, only: %i[new create destroy]
    resources :reservas,  only: %i[create destroy]
  end

  namespace :cantina do
    resources :cardapios do
      resources :cardapio_produtos, only: %i[create destroy]
    end
  end

  resources :redes
  resources :escolas
  root "landing#index"
  get "dashboard", to: "home#index"
end
