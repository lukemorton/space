Rails.application.routes.draw do
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_up: 'sign-up', sign_out: 'logout'}

  root to: redirect('/sign-up')

  resources :help, only: :index

  resources :docks, only: :show

  resources :locations, only: :show

  resources :ships, only: :show do
    scope module: :ships do
      resources :computers, only: :index
      resources :crew, only: :index
      resources :dock_services, only: :index
      resource :flight_deck, only: :show
    end
  end

  resources :people, only: [:new, :create]

  scope module: :actions do
    post :request_to_board, controller: :requesting_to_board
    post :cancel_boarding_request, controller: :requesting_to_board

    post :accept, as: :accept_boarding_request, controller: :moderating_boarding_requests
    post :reject, as: :reject_boarding_request, controller: :moderating_boarding_requests

    post :disembark, controller: :flight
    post :refuel, controller: :flight
    post :travel, controller: :flight
  end

  get '404', to: 'errors#not_found'
  get '422', to: 'errors#unprocessable_entity'
  get '500', to: 'errors#internal_server_error'
end
