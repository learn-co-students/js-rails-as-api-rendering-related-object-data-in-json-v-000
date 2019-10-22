class SightingsController < ApplicationController
  def index
    sightings = Sighting.all
    render json: sightings, include: [:bird, :location]
  end
  
  def show
    sighting = Sighting.find_by(id: params[:id])
    render json: sighting, include: [:bird, :location]
  end
end
