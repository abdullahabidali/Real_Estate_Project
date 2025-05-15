Rails.application.routes.draw do
  # Admin authentication
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # This will be for regular user 
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Property ke routes
  resources :properties do
    member do
      post :favorite
      delete :unfavorite
    end
    resources :messages, only: [:new, :create]
  end

  resources :messages, only: [:index, :show]
  resources :favorites, only: [:index]

  get 'properties/search', to: 'properties#search', as: :search_properties

  # User profile ke routes
  get 'profile', to: 'users#show', as: :profile
  get 'profile/edit', to: 'users#edit', as: :edit_profile
  patch 'profile', to: 'users#update'
  put 'profile', to: 'users#update'
  get 'dashboard', to: 'users#dashboard', as: :dashboard

  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "home#index"
end
