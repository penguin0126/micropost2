Rails.application.routes.draw do
  root to: 'toppages#index'

  resources :microposts, only: [:create, :edit, :update, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users
end
