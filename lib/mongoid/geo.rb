require 'mongoid/geo/shapes'

module Mongoid
  module Geo
    autoload :Config,     'mongoid/geo/config'
    autoload :Formula,    'mongoid/geo/formula'    
    autoload :Unit,       'mongoid/geo/unit'    
    
    def self.config &block
      yield Config if block
      Config
    end
    
  end
end

