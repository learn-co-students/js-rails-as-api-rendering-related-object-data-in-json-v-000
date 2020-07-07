Rails.application.routes.draw do
  resources :sightings
  get '/birds' => 'birds#index'
  get '/birds/:id' => 'birds#show'
  get '/sightings' => 'sightings#index'
  get '/sightings/:id'=> 'sighting#show'
end
