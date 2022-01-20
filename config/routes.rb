Rails.application.routes.draw do
  resources :events

  devise_for :users

  root to: 'events#index'

  resources :products, only: :create

  get '/join/:id', to: 'events#join', as: 'join'
  get '/leave/:id', to: 'events#leave', as: 'leave'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
