module Mongoid
  module Geo
    autoload :Config,     'mongoid/geo/config'
    autoload :Formula,    'mongoid/geo/formula'
    autoload :Shapes,     'mongoid/geo/shapes'
    autoload :Unit,       'mongoid/geo/unit'    
    
    def self.configure &block
      yield Config if block
      Config
    end
    
  end
end

