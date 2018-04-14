Rails.application.routes.draw do
  resources :ships, only: :show

  scope module: :actions do
    post :travel, controller: :flight
  end
end
