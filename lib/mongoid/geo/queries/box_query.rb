require 'mongoid/geo/queries/nested_query'

module Mongoid
  module Geo
    class BoxQuery < NestedQuery

      def initialize box
        super
      end
      
      def to_a
        case box
        when Hash
          [box[:lower_left], box[:upper_right]]
        when Array
          [to_point(box.first), to_point(box.last)]
        else
          box.respond_to?(:lower_left) ? [box.lower_left, box.upper_right] : parse_error!
        end        
      end        

      protected

      def inner_operator
        :box
      end      
      
      def parse_error!
        raise("Can't extract box from: #{box}, must have :lower_left and :upper_right methods or equivalent hash keys in Hash")          
      end
      
      def box
        shape
      end      
    end
  end
end
