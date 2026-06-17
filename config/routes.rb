Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all

  resources :produtos
  resources :categorias
  resources :tabela_precos

  resources :redes
  resources :escolas
  # Defines the root path route ("/")
  root "landing#index"
  get "dashboard", to: "home#index"
end
