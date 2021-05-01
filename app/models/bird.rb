class Bird < ApplicationRecord
  has_many :sightings
  has_many :locationsh, through: :sightings
end
