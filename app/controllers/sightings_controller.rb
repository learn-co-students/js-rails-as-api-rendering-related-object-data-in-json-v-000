class SightingsController < ApplicationController
    def index
        sightings = Sighting.all
        render json: sightings, include: [:bird, :location]
    end

    def show
        sighting = Sighting.find_by(id: params[:id])
        #we can add error messaging
        if sighting
            render json: sighting, include: [:bird, :location]
            # As before with only and except, include is actually just another option that we can pass into the to_json method. 
            # Rails is just obscuring this part:
            # render json: sightings.to_json(include: [:bird, :location])
            # This is also another option:
            # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
        else
            render json: { message: 'No sighting found with that id' }
        end
    end
end
