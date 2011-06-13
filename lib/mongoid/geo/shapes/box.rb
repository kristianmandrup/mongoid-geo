module Mongoid
  module Geo
    class Box < Shape

      def initialize box
        super
      end

      # def to_query op_a, op_b
      #   {"$#{op_a}" => {"$#{op_b}" => to_a } }
      # end
      
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
      
      def parse_error!
        raise("Can't extract box from: #{box}, must have :lower_left and :upper_right methods or equivalent hash keys in Hash")          
      end
      
      def box
        shape
      end      
    end
  end
end
