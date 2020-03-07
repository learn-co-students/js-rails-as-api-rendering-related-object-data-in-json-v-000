class SightingsController < ApplicationController

  def index
    sightings = Sighting.all
    # render json: sightings, include: [:bird, :location]
    # to_json
    render json: sightings.to_json(include: [:bird, :location])
  end

  
  def show
    sighting = Sighting.find_by(id: params[:id])
    # render json: sighting
    # Include the birds
    # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location}

    # Use Include 
    # render json: sighting, include: [:bird, :location]

    # Add error message 
    if sighting
      render json: sighting.to_json(include: [:bird, :location])
    else
      render json: { message: 'No sighting found with that id' }
    end
  end 

end
