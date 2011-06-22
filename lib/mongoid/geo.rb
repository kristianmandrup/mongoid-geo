require 'mongoid/geo/core_ext'
require 'mongoid/geo/config'
require 'mongoid/geo/macros'
require 'mongoid/geo/queries'
# require 'mongoid/geo/document'

module Mongoid
  module Geo
    def self.lng_or_lat?(arg, int = false)
      if lng_symbols.index(arg)
        (int) ? 0 : :lng
      elsif lat_symbols.index(arg)
        (int) ? 1 : :lat
      else
        nil
      end
    end

    def self.lng_symbols
      [:lon, :long, :lng, :longitude]  
    end

    def self.lat_symbols
      [:lat, :latitude]
    end

    def self.config &block
      yield Config if block
      Config
    end    
    
    def self.enable_extensions! *names
      names = names.flatten.uniq
      names = supported_extensions if names == [:all]
      names.each {|name| enable_extension! name }
    end

    def self.enable_extension! name
      case name.to_sym
      when :geo_calc
        require 'geo_calc'        
      when :geo_point
        require 'geo_point'
      when :geo_vectors, :geo_vector
        require 'mongoid/geo/extensions/geo_vectors'
        require 'mongoid/geo/extensions/geo_point'
      end
      
      GeoPoint.coord_mode = :lng_lat if defined?(GeoPoint) && GeoPoint.respond_to?(:lng_lat)
    end    
  end
end

