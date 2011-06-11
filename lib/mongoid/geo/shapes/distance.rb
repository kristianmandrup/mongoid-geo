module Mongoid
  module Geo
    class Distance < Shape 
      def initialize near
        super
      end
            
      def to_query op_a, op_b
        {"$#{op_a}" => to_point(to_a.first), "$#{op_b}" => to_a.last }
      end

      # protected

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
