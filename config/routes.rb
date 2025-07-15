Rails.application.routes.draw do
  resources :games, only: [:index, :create, :show, :update]

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create, :show]

  root "games#index"  
end

