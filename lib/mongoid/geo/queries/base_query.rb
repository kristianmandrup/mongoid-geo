require 'geo_point'

module Mongoid
  module BaseQuery
      attr_reader :shape
      
      def initialize shape
        @shape = shape
      end

      def to_mongo_query
        raise "Must be implemented by subclass"
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