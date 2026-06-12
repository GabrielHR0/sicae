Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  resources :produtos
  resources :categorias

  scope :responsavel do
    get "cardapio", to: "cardapios#index", as: :cardapio_responsavel
    get "cardapio/produto/:produto_id", to: "cardapios#show", as: :cardapio_produto_responsavel
  end

  root "home#index"
end
