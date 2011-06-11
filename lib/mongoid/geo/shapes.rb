module Mongoid
  module Geo
    autoload :Shape,      'mongoid/geo/shapes/shape'
    autoload :Box,        'mongoid/geo/shapes/box'
    autoload :Circle,     'mongoid/geo/shapes/circle'        
    autoload :Distance,   'mongoid/geo/shapes/distance'        
  end
end
