Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  resources :produtos
  resources :categorias

  resources :produtos
  resources :categorias

  resources :redes
  resources :escolas
  # Defines the root path route ("/")
  root "home#index" 
end
