class SightingsController < ApplicationController
    def show
        sighting = Sighting.find_by(id: params[:id])
        if sighting
            render json: sighting, include: [:bird, :location]
        else
            render json: {message: 'oh balls'}
        end
    end 
end
