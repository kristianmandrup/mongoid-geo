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
    end
  end
end