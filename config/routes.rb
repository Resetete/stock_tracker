Rails.application.routes.draw do
  root 'welcome#index'

  get 'my_portfolio', to: 'users#my_portfolio'
  devise_for :users
end
