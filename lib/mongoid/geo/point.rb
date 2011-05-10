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
        return [self['0'].to_f, self['1'].to_f] if self['0']
        raise "Hash must contain either :lat, :lng or :latitude, :longitude keys to be converted to a geo point"
      when nil
        nil
      when Array
        self.map(&:to_f)
      else
        obj   = self.send(:location) if respond_to? :location
        obj ||= self.send(:position) if self.respond_to? :position
        obj ||= self
        get_the_location obj        
      end
    end

    private
    
    def get_the_location obj
      # if Mongoid::Geo.spherical
      #   return [obj.lng, obj.lat] if obj.respond_to? :lat
      #   return [obj.longitude, obj.latitude] if obj.respond_to? :latitude
      # else
        return [obj.lat, obj.lng] if obj.respond_to? :lat
        return [obj.latitude, obj.longitude] if obj.respond_to? :latitude
      # end
      obj.to_f
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