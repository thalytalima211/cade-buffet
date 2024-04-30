Rails.application.routes.draw do
  devise_for :customers, controllers: {registrations: 'customers/registrations'}
  resources :customers, only: [:show]
  devise_for :admins
  resources :buffets, only: [:new, :create, :show, :edit, :update] do
    resources :event_types, only: [:new, :create, :show] do
      resources :orders, only: [:new, :create, :show]
    end
    get 'search', on: :collection
    get 'orders', on: :member
  end
  root to: 'home#index'
end
