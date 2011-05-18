require 'mongoid_geo/index'

module Mongoid
  module Geo
    mattr_accessor :default_units
    mattr_accessor :distance_formula
    mattr_accessor :mongo_db_version

    autoload :Point, 'mongoid_geo/point'
    autoload :Unit, 'mongoid_geo/unit'
    autoload :Fields, 'mongoid_geo/fields'
    autoload :Criteria, 'mongoid_geo/criteria'
    autoload :Near, 'mongoid_geo/near'

    class << self

      def setup
        yield self
      end

      def spherical_mode(&block)
        mode = Mongoid::Geo.distance_formula
        @spherical, old_spherical, result = mode, @spherical, @spherical
        result = yield if block
        @spherical = old_spherical
        result
      end

      def lat_index
        @spherical ? 1 : 0
      end

      def lng_index
        @spherical ? 0 : 1
      end

    end
  end
end
