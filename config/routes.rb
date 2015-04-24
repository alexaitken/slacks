Rails.application.routes.draw do
  resources :sign_ups, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :channels, except: [:update, :destroy], param: :name do
    resources :messages, only: :create
  end

  resource :home, only: :show
  root 'homes#show'
end
