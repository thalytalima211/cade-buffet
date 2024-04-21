Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  resources :buffets, only: [:new, :create, :show, :edit, :update]
  resources :event_types, only: [:new, :create, :show]
  root to: 'home#index'
end
