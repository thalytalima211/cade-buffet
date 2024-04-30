Rails.application.routes.draw do
  devise_for :customers, controllers: {registrations: 'customers/registrations'}
  devise_for :admins
  resources :buffets, only: [:new, :create, :show, :edit, :update] do
    resources :event_types, only: [:new, :create, :show] do
      resources :orders, only: [:new, :create, :show]
    end
    get 'search', on: :collection
  end
  root to: 'home#index'
end
