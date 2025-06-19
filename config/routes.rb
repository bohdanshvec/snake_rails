Rails.application.routes.draw do
  resources :games, only: [:index, :create, :show, :update]# do
    # post :tick, on: :member
  # end

  root "games#index"
end

