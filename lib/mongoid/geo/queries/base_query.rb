module Mongoid
  module Geo
    class BaseQuery
      attr_reader :value
      
      def initialize value
        @value = value
      end

      def to_mongo_query
        raise "Must be implemented by subclass"
      end
      
      def hash?
        !value.kind_of?(Array)
      end      
      
      protected

      def to_point v
        return v.to_lng_lat if v.respond_to? :to_lng_lat
        v
      end
    end
  end
end
