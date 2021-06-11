class SightingsController < ApplicationController
    def show
        sighting = Sighting.find_by(id: params[:id])
        if sighting 
            render json: sighting, include: [:bird, :location], except: [:updated_at, :created_at] 
        else
            render json: { message: 'no sighting foudn with that id'}
        end 
    end 

    def index
        sightings = Sighting.all 
        render json: sightings, include: [:bird, :location]
    end 
end
