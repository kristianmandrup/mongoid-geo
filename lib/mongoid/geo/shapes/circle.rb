module Mongoid
  module Geo
    class Circle < Shape      

      def initialize circle
        super
      end
      
      # def to_query op_a, op_b
      #   {"$#{op_a}" => {"$#{op_b}" => to_a } }
      # end
      
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
      
      def parse_error!
        raise("Can't extract circle from: #{circle}, must have :center and :radius methods or equivalent hash keys in Hash")
      end
      
      def circle
        shape
      end
    end
  end
end


