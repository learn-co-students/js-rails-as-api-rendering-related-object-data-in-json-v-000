class SightingsController < ApplicationController
    def index
        sightings = Sighting.all
        render json: sightings.to_json(include: [:bird, :location])
      end
end
