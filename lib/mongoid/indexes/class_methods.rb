module Mongoid #:nodoc
  module Indexes #:nodoc
    module ClassMethods #:nodoc
      def geo_index name, options = {}
        index [[ name, Mongo::GEO2D ]]
      end
    end
  end
end
