module Mongoid #:nodoc
  module Indexes #:nodoc
    module ClassMethods #:nodoc
      def geo_index name, options = {}
        min = options[:min] || -180
        max = options[:max] || 180
        index [[ name, Mongo::GEO2D ]], :min => min, :max => max

        define_singleton_method :create_index! do
          collection.create_index([[name, Mongo::GEO2D]], :min => min, :max => max)
        end
      end
    end
  end
end

class Array
  def create_geo_indexes!
    self.each {|clazz| clazz.create_index! }
  end
end