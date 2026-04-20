Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks
  resources :users, only: [:new, :create, :show, :edit, :update]

  resources :sessions, only: [:new, :create, :destroy]
  get '/sessions/:id', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end
end