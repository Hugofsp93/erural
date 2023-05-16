Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :videos
      # resources :rooms, only: [:create, :destroy] do
      resources :rooms do
        post 'add_video', on: :member
        post 'play_video', on: :member
      end
    end
  end

  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
end
