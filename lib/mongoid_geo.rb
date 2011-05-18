module Mongoid
  module Geo
    autoload :Point, 'mongoid/geo/point'
    autoload :Unit, 'mongoid/geo/unit'
    autoload :Fields, 'mongoid/geo/fields'
    autoload :Criteria, 'mongoid/geo/criteria'
    autoload :Index, 'mongoid/geo/index'
    autoload :GeoNear, 'mongoid/geo/geo_near'
  end
end
