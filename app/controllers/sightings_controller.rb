class SightingsController < ApplicationController
  def index
    sightings = Sighting.all
    render json: sightings, include: [:bird, :location]
    # same as:
    # render json: sightings.to_json(include: [:bird, :location])
  end

  def show
    # checkout the .bak version of this file for more examples
    sighting = Sighting.find_by(id: params[:id])
    # error handling
    if sighting
      # except here only takes updated and created elements out of sighting
      # render json: sighting, include: [:bird, :location], except: [:updated_at, :created_at]
      # to take it out of all items, this is how you do it, NOTE you have to use ruby's .to_json() method
      render json: sighting.to_json(
        :include => {
          :bird => {:only => [:name, :species]},
          :location => {:only => [:latitude, :longitude]}
        },
        :except => [:updated_at]
      )
    else
      render json: { message: 'Dem birds just ain\'t in these neck of the woods'}
    end
  end
end
