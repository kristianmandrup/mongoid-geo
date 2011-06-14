require 'mongoid/geo/queries/base_query'

module Mongoid
  module Geo
    class TwinQuery < BaseQuery
      attr_reader :shape
      
      def initialize shape
        super
      end

      def to_mongo_query
        {"$#{first_operator}" => to_point(to_a.first), "$#{second_operator}" => to_a.last }
      end

      protected

      def first_operator
        raise "Must be implemented by subclass"
      end      

      def second_operator
        raise "Must be implemented by subclass"
      end      
    end
  end
end