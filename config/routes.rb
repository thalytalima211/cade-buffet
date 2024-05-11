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
      resources :events, only: [:new, :create, :show] do
        post 'confirmed', on: :member
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :buffets, only: [:index, :show] do
        resources :event_types, only: [:index] do
          get 'disponibility', on: :member
        end
      end
    end
  end
  root to: 'home#index'
end
