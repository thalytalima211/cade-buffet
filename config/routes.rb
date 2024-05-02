Rails.application.routes.draw do
  devise_for :customers, controllers: {registrations: 'customers/registrations'}
  resources :customers, only: [:show]
  devise_for :admins
  resources :buffets, only: [:new, :create, :show, :edit, :update] do
    get 'search', on: :collection
    get 'orders', on: :member
  end
  resources :event_types, only: [:new, :create, :show] do
    resources :orders, only: [:new, :create, :show] do
      post 'accepted', on: :member
      post 'cancelled', on: :member
      resources :events, only: [:new, :create, :show]
    end
  end
  root to: 'home#index'
end
