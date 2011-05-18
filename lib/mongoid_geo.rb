require 'mongoid/geo/index'

module Mongoid
  module Geo
    autoload :Point, 'mongoid/geo/point'
    autoload :Unit, 'mongoid/geo/unit'
    autoload :Fields, 'mongoid/geo/fields'
    autoload :Criteria, 'mongoid/geo/criteria'
    autoload :Model, 'mongoid/geo/model'
    autoload :Models, 'mongoid/geo/models'
    autoload :Near, 'mongoid/geo/near'
  end
end
