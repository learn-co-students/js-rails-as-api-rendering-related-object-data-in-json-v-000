class SightingsController < ApplicationController

    def index
        sigthing = Sighting.all 
        render json: SightingSerializer.new(sighting).to_serialized_json
        
    end


    def show
        sighting = Sighting.find_by(id: params[:id])
       
        render json: SightingSerializer.new(sighting).to_serialized_json
    #    Using the Serilazer method we created in the app/service/sighting_serializer
      
    end
    
end
