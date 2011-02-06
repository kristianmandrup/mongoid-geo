module Mongoid::Geo
  module Point
    # convert hash or object to [x, y] of floats
    def to_points
      v = self.kind_of?(Array) ? self.map {|p| p.kind_of?(Fixnum) ? p.to_f : p.extend(Mongoid::Geo::Point).to_point } : self
      v.flatten
    end

    def to_point
      case self
      when Hash
        return [self[:lat], self[:lng]] if self[:lat]
        return [self[:latitude], self[:longitude]] if self[:latitude]
        raise "Hash must contain either :lat, :lng or :latitude, :longitude keys to be converted to a geo point"
      when nil
        nil
      when Array
        self.map(&:to_f)
      else
        return [self.lat, self.lng] if self.respond_to? :lat
        return [self.latitude, self.longitude] if self.respond_to? :latitude
        self.to_f
        # raise 'Object must contain either #lat, #lng or #latitude, #longitude methods to be converted to a geo point'
      end
    end
  end
end
         
module Mongoid::Geo
  module PointConversion
    protected

    def to_point v
      return v if v.kind_of? Fixnum
      v.extend(Mongoid::Geo::Point).to_point
    end

    def to_points v
      return v if v.kind_of? Fixnum 
      v.extend(Mongoid::Geo::Point).to_points
    end
  end
end  