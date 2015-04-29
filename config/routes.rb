Rails.application.routes.draw do
  resources :sign_ups, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :channels, except: [:update, :destroy], param: :name do
    resources :messages, only: :create
  end

  resources :events, only: [:index, :show] do
    collection do
      get 'for/:filter_type/:filter_value', action: :index, as: 'filter'
    end
  end

  resources :projections, only: [:index]

  resource :home, only: :show
  root 'homes#show'
end
