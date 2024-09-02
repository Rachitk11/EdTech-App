module BxBlockLocation
  class Location < ApplicationRecord
    self.table_name = :locations
    reverse_geocoded_by :latitude, :longitude

    belongs_to :van, class_name: 'BxBlockLocation::Van'
  end
end
