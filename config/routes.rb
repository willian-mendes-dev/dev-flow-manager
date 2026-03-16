Rails.application.routes.draw do
  root "sessions#login"

  get "/login", to: "sessions#login"
  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/home", to: "sessions#home"
  match "/logout", to: "sessions#destroy", via: [:delete, :get]
end
