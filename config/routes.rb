Rails.application.routes.draw do
  resources :user_stocks,  only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  root 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'search_stock', to: 'stocks#search'
  get 'search_friend', to: 'friends#search'
  resources :users, only: [:show]
  devise_for :users
end
