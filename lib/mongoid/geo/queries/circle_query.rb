require 'mongoid/geo/queries/nested_query'

module Mongoid
  module Geo
    class CircleQuery < NestedQuery

      def initialize circle
        super
      end
            
      def to_a
        case circle
        when Hash
          [circle[:center], circle[:radius]]
        when Array
          [to_point(circle.first), circle.last]          
        else
          circle.respond_to?(:center) ? [circle.center, circle.radius] : parse_error!
        end
      end      

      protected

      def inner_operator
        :center
      end
      
      def parse_error!
        raise("Can't extract circle from: #{circle}, must have :center and :radius methods or equivalent hash keys in Hash")
      end
      
      def circle
        value
      end
    end
  end
end


