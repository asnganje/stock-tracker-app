Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  root "welcome#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search"
  get 'search_friend', to: 'users#search'
  get 'my_friends', to: 'users#my_friends'
end
