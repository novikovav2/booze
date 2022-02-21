Rails.application.routes.draw do
  get 'profile/update'
  resources :events

  devise_for :users, exclude_routes: %w[edit_user_registration]

  root to: 'events#index'

  resources :products, only: %i[create destroy]

  get '/join/:id', to: 'events#join', as: 'join'
  get '/leave/:id', to: 'events#leave', as: 'leave'

  put 'products/:id/eaters', to: 'products#add_eater', as: 'add_eater'
  delete 'products/:id/eaters', to: 'products#delete_eater', as: 'delete_eater'

  post '/products/complete', to: 'products#addition_complete', as: 'products_complete'

  get '/profile', to: 'profile#index', as: 'profile'
  post '/profile', to: 'profile#new'
  patch '/profile', to: 'profile#update'
  patch '/profile/password', to: 'profile#change_password', as: 'change_password'

  get '/events/:id/results', to: 'events#results', as: 'event_results'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
