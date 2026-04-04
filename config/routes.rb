Rails.application.routes.draw do
  get 'users/new'
  get 'users/create'
  get 'users/show'
  get 'users/edit'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  root 'tasks#index'
  resources :tasks
  resources :users, only: [:new, :create, :edit, :update]

  # Routes for user authentication
  resources :sessions, only: [:new, :create, :destroy]
  #failsafe: catch any get request to a session path and log the user out
  get '/sessions/:id', to: 'sessions#destroy'

  namespace :admin do
    resources :users
  end
end