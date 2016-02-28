Rails.application.routes.draw do
  root to: 'albums#index'

  post 'itunes', to: 'albums#itunes'

  resources :albums
end
