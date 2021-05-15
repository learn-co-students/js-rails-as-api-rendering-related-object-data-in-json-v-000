class SightingsController < ApplicationController
    def index
        sightings = Sighting.All
        render json: sightings, include: [:bird, :location]
    end
    
    def show
        sighting = Sighting.find_by(id: params[:id])
        if sighting
            # # render the sighting information based on the single model
            # render json: sighting
            # # render the associated data with the sighting
            # render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
            # # use the include option instead to indicate what is display
            render json: sighting, include: [:bird, :location]
        else
            render json: { message: 'No sighting found with that id' }
        end
    end
end
