require 'mongoid/geo/queries/base_query'

module Mongoid
  module Geo
    class TwinQuery < BaseQuery      
      def initialize value
        super
      end

      def to_mongo_query
        puts "to_mongo_query: #{value}"
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