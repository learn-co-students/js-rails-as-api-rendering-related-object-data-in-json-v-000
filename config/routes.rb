Rails.application.routes.draw do
  resources :sightings
  resources :locations
  resources :birds
  get '/birds' => 'birds#index'
end