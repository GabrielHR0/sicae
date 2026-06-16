Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: "users/registrations" }
  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all

  resources :produtos
  resources :categorias

  resources :redes
  resources :escolas
  # Defines the root path route ("/")
  root "home#index" 
end
