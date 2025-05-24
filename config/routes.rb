Rails.application.routes.draw do
  # Admin authentication
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # This will be for regular user 
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }

  # Property ke routes
  resources :properties do
    member do
      post :favorite
      delete :unfavorite
    end
    resources :messages, only: [:new, :create, :index]
    resources :property_comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
    resources :reviews, only: :create
  end

  resources :messages, only: [:index, :show]
  resources :favorites, only: [:index]

  # User profile ke routes
  get 'profile', to: 'users#show', as: :profile
  get 'profile/edit', to: 'users#edit', as: :edit_profile
  patch 'profile', to: 'users#update'
  put 'profile', to: 'users#update'
  get 'dashboard', to: 'users#dashboard', as: :dashboard
  get 'roles_debug', to: 'users#roles_debug', as: :roles_debug
  post 'change_role', to: 'users#change_role', as: :change_role

  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"

  # Dashboard redirect route for backward compatibility
  get 'dashboard/index', to: 'users#dashboard'

  # Search route
  # get 'search', to: 'properties#search'

  get 'contact', to: 'contacts#new', as: 'contact'
  post 'contact', to: 'contacts#create'
end
