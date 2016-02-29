Rails.application.routes.draw do
  root to: 'songs#index'

  post 'search', to: 'songs#search'
  get 'run_caching', to: 'songs#run_caching'

  resources :songs, only: [:index]
end
