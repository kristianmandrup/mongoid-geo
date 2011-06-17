require 'mongoid/geo/core_ext'
require 'mongoid/geo/config'
require 'mongoid/geo/macros'
require 'mongoid/geo/queries'

module Mongoid
  module Geo
    LNG_LAT = {
      :lng => 0,
      :long => 0,
      :longitude => 0,
      :lat => 1,
      :latitude => 1,
    }
    # autoload :Config,     'mongoid/geo/config'
    # autoload :Formula,    'mongoid/geo/formula'    
    # autoload :Unit,       'mongoid/geo/unit'    
    def self.config &block
      yield Config if block
      Config
    end    
  end
end

