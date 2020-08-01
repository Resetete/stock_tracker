Rails.application.routes.draw do
  resources :user_stocks,  only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  resources :wallets
  root 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'my_profit', to: 'users#my_profit'
  get 'search_stock', to: 'stocks#search'
  get 'search_friend', to: 'friends#search'
  get 'update_profit/:id', to: 'wallets#update_profit'

  resources :view_users, controller: 'users', only: [:show] 
  devise_for :users
end
