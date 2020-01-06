class SightingsController < ApplicationController

  def show
    sighting = Sighting.find_by(:id => params[:id])
    if sighting
      sighting = Sighting.find_by(id: params[:id])
      render json: sighting.to_json(
        :include => {
          :bird => {
            :only => [:name, :species]},
          :location => {
            :only => [:latitude, :longitude]}
        }, :except => [:updated_at])
    else
      render json: {message: "Sighting not found."}
    end
  end
end


def show
  sighting = Sighting.find_by(id: params[:id])
  render json: sighting.to_json(
    :include => {
    :bird => {:only => [:name, :species]},
    :location => {:only => [:latitude, :longitude]}
  }, :except => [:updated_at])
end