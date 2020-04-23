Rails.application.routes.draw do
  resources :sightings
  get '/birds' => 'birds#index'

  get '/sighting/:id' => 'sightings#show'
end