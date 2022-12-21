Rails.application.routes.draw do
  resources :characterisations
  root "movies#index"

  resources :movies do
    resources :reviews
    resources :favourites, only: [:create, :destroy]
  end
  get "movies/filter/:filter" => "movies#index", as: :filtered_movies

  resources :users
  get "signup" => "users#new"

  resource :session, only: [:new, :create, :destroy]
  get "signin" => "sessions#new"

  resources :genres, except: [:show]
end
