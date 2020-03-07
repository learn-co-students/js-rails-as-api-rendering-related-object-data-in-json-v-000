class Location < ApplicationRecord
    has_many :sights
    has_many :locations, through: :signtings
    end

end