Rails.application.routes.draw do
  root to: 'toppages#index'

  resources :microposts, only: [:create, :edit, :update, :destroy]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  resources :users do
    member do
      get :followings
      get :followers
      get :favorite_posts
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
