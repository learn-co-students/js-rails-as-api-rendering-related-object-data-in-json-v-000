Rails.application.routes.draw do
  resources :sightings, only: [:index, :show]
  get '/birds' => 'birds#index'
end
