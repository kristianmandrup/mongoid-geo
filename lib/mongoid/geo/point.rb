module Mongoid::Geo
  module Point
    # convert hash or object to [x, y] of floats
    def to_points
      case self
      when Hash
        return [self[:lat], self[:lng]] if self[:lat]
        return [self[:latitude], self[:longitude]] if self[:latitude]
        raise "Hash must contain either :lat, :lng or :latitude, :longitude keys to be converted to a geo point"
      else
        return [self.lat, self.lng] if self.respond_to? :lat
        return [self.latitude, self.longitude] if self.respond_to? :latitude
        self
        # raise 'Object must contain either #lat, #lng or #latitude, #longitude methods to be converted to a geo point'
      end
    end
  end
end
