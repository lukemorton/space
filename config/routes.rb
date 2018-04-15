Rails.application.routes.draw do
  resources :locations, only: :show
  resources :ships, only: :show

  scope module: :actions do
    post :travel, controller: :flight
  end
end
