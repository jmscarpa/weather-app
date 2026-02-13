Rails.application.routes.draw do
  root to: "home#index"
  post "/search", to: "home#search", as: :search
end
