Rails.application.routes.draw do
  resources :styles
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_disabled', on: :member
  end

  get 'signup', to: 'users#new'

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'


  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'

  resources :ratings, only: [:index, :new, :create, :destroy]

  root 'breweries#index'

  resource :session, only: [:new, :create, :destroy]

  resources :places, only: [:index, :show]

  post 'places', to: 'places#search'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

