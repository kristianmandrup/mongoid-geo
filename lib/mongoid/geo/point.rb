module Mongoid::Geo
  module Point
    def to_points
      coordinates = self.kind_of?(Array) ? self.map{|coordinate| coordinate.to_f} : self.to_point
      coordinates.flatten
    end

    def to_point
      case self
      when Hash
        return [self[:lng], self[:lat]] if self[:lat] && self.has_key?(:lat) && self.has_key?(:lng)
        return [self[:longitude], self[:latitude]] if self.has_key?(:longitude) && self.has_key?(:latitude)
        raise "Hash must contain either :lat, :lng or :latitude, :longitude keys to be converted to a geo point"
      else
        return self.to_lng_lat if self.respond_to?(:to_lng_lat) # GeoPoint from geo_calc gem
        raise "Invalid Geo Input. Please use either a Hash or an Array. Remember that Longitude must always be the first value in an Array."
      end
    end
  end
end

module Mongoid::GeoPoint
  def lat= value
    self[Mongoid::Geo.lat_index] = value
  end            

  def lng= value
    self[Mongoid::Geo.lng_index] = value
  end            

  def lat
    self[Mongoid::Geo.lat_index]
  end            
  
  def lng
    self[Mongoid::Geo.lng_index]
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

class Array
  def to_geopoint                              
    self.extend(Mongoid::GeoPoint)
  end
end
