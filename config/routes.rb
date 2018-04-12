Rails.application.routes.draw do
  resources :people, only: :show

  scope module: :actions do
    post :travel, controller: :flight
  end
end
