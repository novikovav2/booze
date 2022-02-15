Rails.application.routes.draw do
  resources :events

  devise_for :users

  root to: 'events#index'

  resources :products, only: %i[create destroy]

  get '/join/:id', to: 'events#join', as: 'join'
  get '/leave/:id', to: 'events#leave', as: 'leave'

  put 'products/:id/eaters', to: 'products#add_eater', as: 'add_eater'
  delete 'products/:id/eaters', to: 'products#delete_eater', as: 'delete_eater'

  post '/products/complete', to: 'products#addition_complete', as: 'products_complete'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
