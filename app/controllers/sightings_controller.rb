class SightingsController < ApplicationController
  def index
    sightings = Sighting.all
    render json: sightings, include: [:bird, :location]
  end

  def show
    sighting = Sightiing.find_by(id: params[:id])
    if sighting
      #render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
      render json: sighting, include: [:bird, :location]
    else
      render json: { message: 'no sightings found with that id' }
    end
  end
end
