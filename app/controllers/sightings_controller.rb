class SightingsController < ApplicationController
  def index
    sightings = Sighting.all
    render json: sightings, include: [:bird, :location]
  end

  def show
    sighting = Sighting.find_by(id: params[:id])
    # render json: sightingrender json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
    # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
    # render json: sighting, include: [:bird, :location]
    if sighting
      render json: sighting, include: [:bird, :location], except: [:updated_at]
    else
      render json: { message: 'No sighting found with that id' }
    end
  end
end
