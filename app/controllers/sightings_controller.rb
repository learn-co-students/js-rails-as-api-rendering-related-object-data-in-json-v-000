class SightingsController < ApplicationController

  def index
    sightings = Sighting.all
    render json: sightings, include: [:bird, :location]
    # rails is just obscuring: render json: sightings.to_json(include: [:bird, :location])
  end

  def show
    sighting = Sighting.find_by(id: params[:id])
    # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
    # render json: sighting, include: [:bird, :location]
    if sighting
      render json: sighting.to_json(include: [:bird, :location])
    else
      render json: { message: 'No sighting was found with that id'}
    end
  end

  # def show
  #   sighting = Sighting.find_by(id: params[:id])
  #   render json: sighting.to_json(:include => {
  #     :bird => { :only => [:name, :species]},
  #     :location => {:only => [:latitude, :longitude]}
  #     }, :except => [:updated_at])
  # end
end
