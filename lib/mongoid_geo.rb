require 'mongoid_geo/index'

module Mongoid
  module Geo
    include ActiveSupport::Configurable
    config_accessor :mongo_db_version
    config_accessor :distance_formula
    config_accessor :default_units

    autoload :Point, 'mongoid_geo/point'
    autoload :Unit, 'mongoid_geo/unit'
    autoload :Fields, 'mongoid_geo/fields'
    autoload :Criteria, 'mongoid_geo/criteria'
    autoload :Model, 'mongoid_geo/model'
    autoload :Models, 'mongoid_geo/models'
    autoload :Near, 'mongoid_geo/near'
  end
end
