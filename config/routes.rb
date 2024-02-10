Rails.application.routes.draw do
  resources :orders
  resources :dishes
  resources :restaurants
  resources :users

  post "sign_up", to: "users#sign_up_user"
  post "login", to: "oauth#login"

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
