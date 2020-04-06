class SightingsController < ApplicationController
  def show
    sighting = Sighting.all
    render json: sighting.to_json(:include => {
    :bird => {:only => [:name, :species]},
    :location => {:only => [:latitude, :longitude]}
  }, :except => [:updated_at])
  end
end
