require 'mongoid/geo/queries/twin_query'

module Mongoid
  module Geo
    class DistanceQuery < TwinQuery
      def initialize near
        super
      end
                  
      def to_a
        case near
        when Hash
          [near[:point], near[:distance]]
        when Array
          [to_point(near.first), near.last]
        else
          near.respond_to?(:point) ? [near.point, near.distance] : parse_error!
        end
      end      

      protected

      def first_operator
        :near
      end

      def second_operator
        :maxDistance
      end
      
      def parse_error!
        raise("Can't extract nearMax values from: #{near}, must have :point and :maxDistance methods or equivalent hash keys in Hash")
      end
      
      def near
        value
      end
    end
  end
end
