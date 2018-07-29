Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'sign-up', sign_out: 'logout'}

  root to: redirect('/sign-up')

  resources :docks, only: :show
  resources :locations, only: :show
  resources :ships, only: :show

  scope module: :actions do
    post :disembark, controller: :flight
    post :board, controller: :flight
    post :travel, controller: :flight
  end
end
