Rails.application.routes.draw do
  root "sessions#login"

  get "/login", to: "sessions#login"
  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/home", to: "home#index"
  post "/home/generate_insights", to: "home#generate_insights", as: :generate_home_insights
  resources :products
  match "/logout", to: "sessions#destroy", via: [:delete, :get]
end
