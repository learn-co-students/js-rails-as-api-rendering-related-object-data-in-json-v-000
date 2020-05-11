class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render json: @birds
  end
  def show #In the SightingsController, now that the resources are created and connected, we should be able to confirm our data has been created by including a basic show action:
    sighting = Sighting.find_by(id: params[:id])
    render json: sighting
  end
end