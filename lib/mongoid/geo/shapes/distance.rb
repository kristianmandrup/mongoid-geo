module Mongoid
  module Geo::Shapes
    class Distance < Shape 
      def initialize near
        super
      end
      
      def to_a
        case v
        when Hash
          [near[:point], near[:distance]]
        when Array
          [to_point(near.first), near.last]
        else
          near.respond_to?(:point) ? [near.point, near.distance] : parse_error!
        end
      end

      private
      
      def parse_error!
        raise("Can't extract nearMax values from: #{near}, must have :point and :maxDistance methods or equivalent hash keys in Hash")
      end
      
      def near
        shape
      end
    end
  end
end
