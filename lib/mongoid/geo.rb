require 'geo_point'

GeoPoint.coord_mode = :lng_lat

require 'mongoid/geo/config'
require 'mongoid/geo/macros'
require 'mongoid/geo/queries'

module Mongoid
  module Geo
    # autoload :Config,     'mongoid/geo/config'
    # autoload :Formula,    'mongoid/geo/formula'    
    # autoload :Unit,       'mongoid/geo/unit'    
    
    def self.config &block
      yield Config if block
      Config
    end
    
  end
end

