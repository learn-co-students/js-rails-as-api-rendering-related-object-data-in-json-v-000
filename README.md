# Rendering Related Data in JSON Using Rails

## Learning Goals

- Review Rails generators
- Render related models as nested JSON data

## Introduction

Using `only` and `except`, we can be selective in what attributes we want to
render to JSON in our basic Rails API. But what if we want to be _inclusive_
rather than selective? With Rails models, we're often dealing with many
different related objects. Using `include` when rendering JSON, our API can send
data about one resource along with data about its associated resources.

In this lesson, we will look at how our Rails API will be able to convey
relationships between multiple models in a single JSON object. In order to fully
understand `include`, however, we'll need to expand our example domain so
that we have a few related resources to work with.

## Setting up Additional Related Resources To Include - Bird Sightings

In the last few code-alongs, we've been playing around with a basic resource,
`Bird` for a bird watching application. The `Bird` resource is already set up in
this lesson with `name` and `species` attributes. We could imagine in a fully
developed bird watching application that birds would come up a lot. Likely, the
same type of bird will come up a lot, so a `Bird` model makes sense.

We could imagine, as well, if we were to expand on this application, a logical
next step for bird watching might be some sort of location-based _bird sighting_
system. A user of this site might one day be able to log the sighting of rare
birds in their backyard.

<p align="center">
  <img width="500" src="https://curriculum-content.s3.amazonaws.com/js/rails-as-an-api/Image_16_BirdSighting.png">
</p>

The next resource to build, then, might be `Location` so we could connect
specific birds to specific locations. To speed things up, let's use the `model`
generator Rails provides. We can also give `Location` a few attributes,
`latitude` and `longitude`:

```sh
rails g model location latitude:float longitude:float
```

The `model` generator creates the migration and model for us here which is all
we will need in this case.

We can create one more resource, a `Sighting`. A `Sighting` will connect a
specific bird and location. A bird sighting in real life is an event that ties
birds to their locations at a specific time. Similarly, a `Sighting` will do
the same by tying one `Bird` to one `Location`.

In the next part of this lesson, we'll add a controller action for this
`Sighting` resource, so this time, rather than using `model` to create our
files, we can use the `resource` generator. In addition, since we have
two existing resources we're connecting, we can use the `references` keyword
when listing them, and Rails will automatically connect them:

```sh
rails g resource sighting bird:references location:references
```

This generates a migration with `references`:

```ruby
class CreateSightings < ActiveRecord::Migration[5.2]
  def change
    create_table :sightings do |t|
      t.references :bird, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
  end
end
```

Running `rails db:migrate` now will produce slightly different schema, but if we
look at the file, we see it still connects the `"birds"` and `"locations"` 
tables to the `"sightings"` table by id:

```ruby
create_table "sightings", force: :cascade do |t|
  t.integer "bird_id"
  t.integer "location_id"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["bird_id"], name: "index_sightings_on_bird_id"
  t.index ["location_id"], name: "index_sightings_on_location_id"
end
```

The other effect of using `references` in the generator is that it will add
relationships automatically to the generated model:

```ruby
class Sighting < ApplicationRecord
  belongs_to :bird
  belongs_to :location
end
```

The other models will remain unaltered, so we'll have to update them. A bird
may show up many times so it could be argued that a bird _has many_ sightings.
The same would apply for a location. Through sightings, birds have many locations,
and vice versa, so we would update our models to reflect these. Add the
following relationships to the `Bird` and `Location` models:

```rb
class Bird < ApplicationRecord
  has_many :sightings
  has_many :locations, through: :sightings
end
```

```rb
class Location < ApplicationRecord
  has_many :sightings
  has_many :birds, through: :sightings
end
```

With the extra resources, we'll need additional seed data to test everything
out. Update `db/seeds.rb` with the following then run `rails db:seed` to set up
the example data.

```ruby
bird_a = Bird.create(name: "Black-Capped Chickadee", species: "Poecile Atricapillus")
bird_b = Bird.create(name: "Grackle", species: "Quiscalus Quiscula")
bird_c = Bird.create(name: "Common Starling", species: "Sturnus Vulgaris")
bird_d = Bird.create(name: "Mourning Dove", species: "Zenaida Macroura")

location_a = Location.create(latitude: "40.730610", longitude: "-73.935242")
location_b = Location.create(latitude: "30.26715", longitude: "-97.74306")
location_c = Location.create(latitude: "45.512794", longitude: "-122.679565")

sighting_a = Sighting.create(bird: bird_a, location: location_b)
sighting_b = Sighting.create(bird: bird_b, location: location_a)
sighting_c = Sighting.create(bird: bird_c, location: location_a)
sighting_d = Sighting.create(bird: bird_d, location: location_c)
sighting_e = Sighting.create(bird: bird_a, location: location_b)
```

With three related resources created, we can begin working on rendering them in
JSON.

## Including Related Models in a Single Controller Action

In the `SightingsController`, now that the resources are created and connected,
we should be able to confirm our data has been created by including a
basic `show` action:

```ruby
def show
  sighting = Sighting.find_by(id: params[:id])
  render json: sighting
end
```

With the Rails server running, visiting `http://localhost:3000/sightings/1`
should produce an object representing a _sighting_: 

```js
{
  "id": 1,
  "bird_id": 1,
  "location_id": 2,
  "created_at": "2019-05-14T11:20:37.225Z",
  "updated_at": "2019-05-14T11:20:37.225Z"
}
```

> **ASIDE:** Notice that the object includes its own `"id"`, as well as the
> related `"bird_id"` and `"location_id"`. That is useful data. We _could_ use
> these values to send additional requests using JavaScript to get bird and
> location data if needed.

To include bird and location information in this controller action, now that our
models are connected, the most direct way would be to build a custom hash like 
we did in the previous lesson:

```ruby
def show
  sighting = Sighting.find_by(id: params[:id])
  render json: { id: sighting.id, bird: sighting.bird, location: sighting.location }
end
```

This produces nested objects in our rendered JSON for `"bird"` and `"location"`:

```js
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
```

Often, this works perfectly fine to get yourself started, and is more than
enough to begin testing against with `fetch()` requests on a frontend.

## Using `include`

An alternative is to use the `include` option to indicate what models
you want to nest:

```ruby
def show
  sighting = Sighting.find_by(id: params[:id])
  render json: sighting, include: [:bird, :location]
end
```

This produces similar JSON as the previous custom configuration:

```js
{
  "id": 2,
  "bird_id": 2,
  "location_id": 2,
  "created_at": "2019-05-14T11:20:37.228Z",
  "updated_at": "2019-05-14T11:20:37.228Z",
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
```

All attributes of included objects will be listed by default. Using `include:`
also works fine when dealing with an action that renders an array, like when we use `all`
in `index` actions:

```ruby
def index
  sightings = Sighting.all
  render json: sightings, include: [:bird, :location]
end
```

As before with `only` and `except`, `include` is actually just another option
that we can pass into the `to_json` method. Rails is just _obscuring_ this part:

```ruby
def index
  sightings = Sighting.all
  render json: sightings.to_json(include: [:bird, :location])
end

def show
  sighting = Sighting.find_by(id: params[:id])
  render json: sighting.to_json(include: [:bird, :location])
end
```

And adding some error handling on our `show` action:

```ruby
def show
  sighting = Sighting.find_by(id: params[:id])
  if sighting
    render json: sighting.to_json(include: [:bird, :location])
  else
    render json: { message: 'No sighting found with that id' }
  end
end
```

## Conclusion

We see now that within a single controller action, it is possible to render
related models as nested JSON data! If we imagine how this app might continue to
develop, now that we have a way for birds to be tied to locations by _sightings_,
we could start to work on a way for these sightings to be created in a browser.
We could also continue to expand on endpoints for this API. We now have the
ability for specific types of birds to tell us _where_ they've been sighted, for
instance.

When nesting models in JSON the way we saw in this lab, it is entirely possible
to use `include` in conjunction with `only` and `exclude`. For instance, if
we wanted to remove the `:updated_at` attribute from `Sighting` when rendered:

```ruby
def show
  sighting = Sighting.find_by(id: params[:id])
  render json: sighting, include: [:bird, :location], except: [:updated_at]
end
```

But this begins to complicate things significantly as we work with nested
resources and try to limit what _they_ display.

For example, to _also_ remove all instances of `:created_at` and `:updated_at`
from the nested bird and location data in the above example, we'd have to
add nesting into the _options_, so the included bird and location data can
have their own options listed. Using the fully written `to_json` render statement
can help keep things a bit more readable here:

```ruby
def show
  sighting = Sighting.find_by(id: params[:id])
  render json: sighting.to_json(:include => {
    :bird => {:only => [:name, :species]},
    :location => {:only => [:latitude, :longitude]}
  }, :except => [:updated_at])
end
```

This does produce a more specific set of data:

```js
{
  "id": 2,
  "bird_id": 2,
  "location_id": 2,
  "created_at": "2019-05-14T11:20:37.228Z",
  "bird": {
    "name": "Grackle",
    "species": "Quiscalus Quiscula"
  },
  "location": {
    "latitude": 30.26715,
    "longitude": -97.74306
  }
}
```

A single sighting of Quiscalus Quiscula on May 14th, 2019 in downtown Austin,
Texas!

While that is neat, it seems silly to have to include such a complicated render
line in our action. In addition, in this example we're only dealing with three
models. Customizing what is rendered in a larger set of nested data could
quickly turn into a major headache.

Now that we have covered how to customize and shape Rails model data into JSON,
we can start to look at options for keeping that data well organized when
building more complicated APIs.

