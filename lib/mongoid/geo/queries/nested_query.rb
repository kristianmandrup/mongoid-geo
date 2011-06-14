require 'mongoid/geo/queries/base_query'

module Mongoid
  module Geo
    class NestedQuery < BaseQuery
      attr_reader :shape
      
      def initialize shape
        super
      end

      def to_mongo_query
        {"$#{outer_operator}" => {"$#{inner_operator}" => to_a } }
      end
            
      protected

      def outer_operator
        :within
      end      
      
      def inner_operator
        raise "Must be implemented by subclass"        
      end
    end
  end
end