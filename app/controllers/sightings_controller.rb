class SightingsController < ApplicationController

  def index
    sightings = Sighting.all
    # render json: sightings, include: [:bird, :location]

    # As before with only and except, include is actually just another option
    # that we can pass into the to_json method. Rails is just obscuring this part:
    render json: sightings.to_json(include: [:bird, :location])
  end

  def show
    sighting = Sighting.find_by(id: params[:id])
    # render json: sighting

    # To include bird and location information in this controller action,
    # now that our models are connected, the most direct way would be to
    # build a custom hash like we did in the previous lesson:
    # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }

    # An alternative is to use the include option to indicate what models you want to nest:
    # render json: sighting, include: [:bird, :location]

    # As before with only and except, include is actually just another option
    # that we can pass into the to_json method. Rails is just obscuring this part:
    # render json: sighting.to_json(include: [:bird, :location])

    # And adding some error handling on our show action:
    if sighting
      # render json: sighting.to_json(include: [:bird, :location])
      # ...if we wanted to remove the :updated_at attribute from Sighting when rendered:
      # render json: sighting, include: [:bird, :location], except: [:updated_at]

      # But this begins to complicate things significantly as we work with nested
      # resources and try to limit what they display...Using the fully written
      # to_json render statement can help keep things a bit more readable here:
      render json: sighting.to_json(:include => {
        :bird => {:only => [:name, :species]},
        :location => {:only => [:latitude, :longitude]}
      }, :except => [:updated_at])
    else
      render json: { message: 'No sighting found with that id' }
    end
  end

end
