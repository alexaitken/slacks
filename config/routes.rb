Rails.application.routes.draw do
  resources :sign_ups, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]

  resources :channels, except: [:update, :destroy], param: :name do
    resources :messages, only: :create
    resources :members, only: :create
  end

  namespace :vent_source do
    resources :events, only: [:index, :show] do
      collection do
        get 'for/:filter_type/:filter_value', action: :index, as: 'filter'
      end
    end

    resources :projections, only: [:index]
  end

  resource :home, only: :show
  root 'homes#show'

  mount ActionCable.server => '/cable'
end
