class SightingsController < ApplicationController
  def show
    sighting = Sighting.find_by(id: params[:id])
    render json: sighting, include: [:bird, :location]
  end
end
