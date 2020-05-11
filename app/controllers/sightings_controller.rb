class SightingsController < ApplicationController

    def index
        sightings = Sighting.all
        #render json: sightings, include: [:bird, :location]
        #Using include: also works fine when dealing with an action that renders an array, like when we use all in index actions:
        sightings.to_json(include: [:bird, :location])
      end

    def show
        sighting = Sighting.find_by(id: params[:id])
        #render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
        #An alternative is to use the include option to indicate what models you want to nest:
        #render json: sighting, include: [:bird, :location]
        #sightings.to_json(include: [:bird, :location])
        if sighting #And adding some error handling on our show action:
            render json: sighting.to_json(include: [:bird, :location])
          else
            render json: { message: 'No sighting found with that id' }
          end
      end
end

#All attributes of included objects will be listed by default. Using include: also works fine when dealing with an action that renders an array, like when we use all in index actions: