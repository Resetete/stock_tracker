Rails.application.routes.draw do
  resources :user_stocks,  only: [:create]
  root 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  get 'search_stock', to: 'stocks#search'
  devise_for :users
end
