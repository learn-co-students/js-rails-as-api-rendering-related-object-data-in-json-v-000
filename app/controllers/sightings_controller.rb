class SightingsController < ApplicationController

    def show
        sighting = Sighting.find_by(id: params[:id])
        render json: sighting.to_json(:include => {
          :bird => {:only => [:name, :species]},
          :location => {:only => [:latitude, :longitude]}
        }, :except => [:updated_at])
    end

    def index
        sightings = Sighting.all
        render json: sightings, include: [:bird, :location]
    end

end
