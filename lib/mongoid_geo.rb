require 'mongoid_geo/index'

module Mongoid
  module Geo
    mattr_accessor :default_units
    mattr_accessor :distance_formula
    mattr_accessor :mongo_db_version

    default_unit = self.default_units ||= :km
    distance_formula = self.distance_formula ||= :spherical
    mongo_db_version = self.mongo_db_version ||= 1.8

    autoload :Point, 'mongoid_geo/point'
    autoload :Unit, 'mongoid_geo/unit'
    autoload :Fields, 'mongoid_geo/fields'
    autoload :Criteria, 'mongoid_geo/criteria'
    autoload :Model, 'mongoid_geo/model'
    autoload :Models, 'mongoid_geo/models'
    autoload :Near, 'mongoid_geo/near'

    def self.setup
      yield self
    end

  end
end
