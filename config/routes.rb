Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  get 'signup', to: 'users#new'

  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'

  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]

  root 'breweries#index'

  resource :session, only: [:new, :create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

