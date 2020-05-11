def show
  sighting = Sighting.find_by(id: params[:id])
  render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
end

{
  "id": 2,
  "bird": {
    "id": 2,
    "name": "Grackle",
    "species": "Quiscalus Quiscula",
    "created_at": "2019-05-14T11:20:37.177Z",
    "updated_at": "2019-05-14T11:20:37.177Z"
  },
  "location": {
    "id": 2,
    "latitude": 30.26715,
    "longitude": -97.74306,
    "created_at": "2019-05-14T11:20:37.196Z",
    "updated_at": "2019-05-14T11:20:37.196Z"
  }
}