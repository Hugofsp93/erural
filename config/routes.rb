Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :rooms do
        resources :videos
        post 'add_video', on: :member
        post 'play_video', on: :member
        get 'videos', on: :member
        get '/access/:access_code', to: 'rooms#access', as: 'room_access'
      end
    end
  end

  root to: "home#index"

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  post "signup", controller: :signup, action: :create
  delete "signin", controller: :signin, action: :destroy
end
