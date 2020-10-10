class SightingsController < ApplicationController

    def show
        @sighting = Sighting.find_by(id: params[:id])
        # render json: @sighting

        # mixiin data from collaborating objects
        # render json: {id: @sighting.id, bird: @sighting.bird, location: @sighting.location}

        # even shorter syntax
        render json: @sighting, include: [:bird, :location]
    end


end
