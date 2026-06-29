Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all

  resources :produtos
  resources :categorias
  resources :responsaveis
  resources :estudantes
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