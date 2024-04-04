Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :mentorship_requests, only: %i[new create index show update destroy] do
    member do
      patch 'accept', to: 'mentorship_requests#accept', as: 'accept_mentorship_request'
      patch 'cancel', to: 'mentorship_requests#cancel', as: 'cancel_mentorship_request'
    end
  end
  resources :chatrooms, only: :show do
    resources :messages, only: :create
  end
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new', as: 'new_user_session'
    post 'sign_in', to: 'users/sessions#create', as: 'user_session'
    delete 'sign_out', to: 'users/sessions#destroy', as: 'destroy_user_session'
  end

  root to: 'pages#homepage'
  get '/search', to: 'pages#search', as: 'search'
  get '/profile', to: 'pages#profile'

  get 'users/:id', to: 'users#show', as: 'user'
  get '/matches', to: 'pages#matches', as: 'matches'
  patch '/mentorship_requests/:id/accept', to: 'mentorship_requests#accept', as: 'accept_mentorship_request'
  patch '/mentorship_requests/:id/cancel', to: 'mentorship_requests#cancel', as: 'cancel_mentorship_request'

  # Updated users resource to include edit and update actions
  resources :users, only: [:show, :edit, :update]
end
