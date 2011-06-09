module Mongoid
  module Geo
    class Shape
      attr_reader :shape
      
      def initialize shape
        @shape = shape
      end
      
      def hash?
        !shape.kind_of?(Array)
      end      
    end
  end
end