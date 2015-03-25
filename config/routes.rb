Rails.application.routes.draw do
  resources :signups, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resource :home, only: :show
end
