require 'geo_vectors'

class Array
  def to_geo_hash
    {:lat => self[1], :lng => self[0]}
  end

  def sub!(geo_vector)
    add! geo_vector.reverse
  end

  def add!(geo_vector)
    new_point = GeoPoint.new(self.to_geo_hash).add! geo_vector
    self[0] = new_point.lng
    self[1] = new_point.lat
    self
  end
end