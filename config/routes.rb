Rails.application.routes.draw do
  resources :sign_ups, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resource :home, only: :show
  root 'homes#show'
end
