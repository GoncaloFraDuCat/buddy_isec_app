Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: 'new_user_session'
    post 'sign_in', to: 'users/sessions#create', as: 'user_session'
    delete 'sign_out', to: 'users/sessions#destroy', as: 'destroy_user_session'
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  root to: 'pages#homepage'
  get '/search', to: 'pages#search', as: 'search'
  get '/profile', to: 'pages#profile'
  get '/matches', to: 'pages#matches'
  get 'users/:id', to: 'users#show', as: 'user'
end
