class SightingsController < ApplicationController
    def index
        sightings = Sighting.all
        render json: sightings, include: [:bird, :location]
    end
    
    def show
       sighting = Sighting.find(params[:id])
        if sighting
        #   custom hash method:  render json: {id: sighting.id, bird: sighting.bird, location: sighting.location} 
        #   using include:  render json: sighting, include: [:bird, :location]

        #   adding nested data filters  (writing out full to_json syntax for clarity)
            render json: sighting.to_json(:include => {
                :bird => {:only => [:name, :species]},
                :location => {:only => [:latitude, :longitude]}
            }, :except => [:updated_at])
        else
            render json: {message: 'No sighting found with that id'}
        end
    end
end
