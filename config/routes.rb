Rails.application.routes.draw do
  root to: 'songs#index'

  post 'itunes', to: 'albums#itunes'

  resources :albums
  resources :songs
end
