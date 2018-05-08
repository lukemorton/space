Rails.application.routes.draw do
  resources :docks, only: :show
  resources :locations, only: :show
  resources :ships, only: :show

  scope module: :actions do
    post :travel, controller: :flight
    post :disembark, controller: :flight
  end
end
