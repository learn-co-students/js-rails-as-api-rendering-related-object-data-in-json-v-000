class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    # render json: @birds
    render json: sightings, include: [:bird, :location]
  end
end
