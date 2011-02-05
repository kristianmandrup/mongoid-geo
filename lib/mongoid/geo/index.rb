module Mongoid #:nodoc
  module Indexes #:nodoc
    module ClassMethods #:nodoc
      def geo_index name
        index [[ name, Mongo::GEO2D ]], :min => -180, :max => 180
      end
    end
  end
end
