Rails.application.routes.draw do
  resources :redes
  resources :escolas
  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  resources :produtos
  resources :categorias

  # Defines the root path route ("/")
  root "home#index"
end
