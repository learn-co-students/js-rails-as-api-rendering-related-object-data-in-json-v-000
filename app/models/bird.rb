class Bird < ApplicationRecord
    has_many :locations
    has_many :sightings, through: :location
end