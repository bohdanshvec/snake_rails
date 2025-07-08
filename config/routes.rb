Rails.application.routes.draw do
  resources :games, only: [:index, :create, :show, :update]

  root "games#index"
end

