require 'geo_calc'

GeoPoint.coord_mode = :lng_lat

module Mongoid
  module Geo
    class Shape
      attr_reader :shape
      
      def initialize shape
        @shape = shape
      end

      def to_query op_a, op_b
        {"$#{op_a}" => {"$#{op_b}" => to_a } }
      end
      
      def hash?
        !shape.kind_of?(Array)
      end      
      
      protected
      
      def to_point v
        v.geo_point.to_lng_lat
      end
    end
  end
end