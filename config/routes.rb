Rails.application.routes.draw do
  devise_for :customers, controllers: {registrations: 'customers/registrations'}
  devise_for :admins
  resources :buffets, only: [:new, :create, :show, :edit, :update] do
    get 'search', on: :collection
  end
  resources :event_types, only: [:new, :create, :show]
  root to: 'home#index'
end
