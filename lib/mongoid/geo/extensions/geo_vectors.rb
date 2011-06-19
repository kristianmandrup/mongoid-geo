require 'geo_vectors'
require 'geo_vectors/macros'

GeoPoint.coord_mode = :lng_lat

class Array
  def to_geo_hash
    {:lng => self[0], :lat => self[1] }
  end

  def sub!(geo_vector)
    raise ArgumentError, "Must be a GeoVector, was: #{geo_vector}" unless geo_vector.any_kind_of?(GeoVector, GeoVectors)
    add! geo_vector.reverse
  end

  def add!(geo_vector)
    raise ArgumentError, "Must be a GeoVector, was: #{geo_vector}" unless geo_vector.any_kind_of?(GeoVector, GeoVectors)
    new_point = GeoPoint.new(self.to_geo_hash).add! geo_vector
    self[0] = new_point.lng
    self[1] = new_point.lat
    self
  end
end