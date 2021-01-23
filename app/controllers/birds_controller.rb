class BirdsController < ApplicationController
  def index
    @birds = Bird.all
    render json: @birds
  end

  def show
    sighting = Sighting.find_by(id: params[:id])
    render json: sighting
  end

end