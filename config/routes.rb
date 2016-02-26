Rails.application.routes.draw do
  root to: 'albums#search'

  post 'itunes', to: 'albums#itunes'
end
