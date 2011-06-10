require 'geo_vectors'

class Array
  def to_geo_hash
    {:lng => self[0], :lat => self[1] }
  end

  def sub!(geo_vector)
    raise ArgumentException, "Must be a GeoVector, was: #{geo_vector}" unless geo_vector.kind_of?(GeoVector)
    add! geo_vector.reverse
  end

  def add!(geo_vector)
    raise ArgumentException, "Must be a GeoVector, was: #{geo_vector}" unless geo_vector.kind_of?(GeoVector)
    new_point = GeoPoint.new(self.to_geo_hash).add! geo_vector
    self[0] = new_point.lng
    self[1] = new_point.lat
    self
  end
end