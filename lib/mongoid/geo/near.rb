#require 'net/http'
require 'active_support'
require 'mongoid/geo/haversine'

module Mongoid
  module Geo
    class << self
      attr_accessor :mongo_db_version
      attr_accessor :spherical

      def spherical_mode mode = true, &block
        @spherical, old_spherical, result = mode, @spherical, @spherical
        result = yield if block
        @spherical = old_spherical
        result
      end

      def lat_index
        @spherical ? 1 : 0
      end

      def lng_index
        @spherical ? 0 : 1
      end
    end

    module Near

      attr_accessor :from_hash, :from_point, :distance

      def geoNear(center, location_attribute, options = {})
        center = (center.respond_to?(:collection) && center.respond_to?(location_attribute)) ? center.public_send(location_attribute) : center
        query = create_query(self, center, options)
        query_result(self, query, center, location_attribute, options)
      end
      alias_method :geo_near, :geoNear

      protected

      def create_query klass, center, options = {}
        BSON::OrderedHash.new.tap do |near_query|
          near_query["geoNear"]      = klass.to_s.tableize
          near_query["near"]         = center
          near_query["num"]          = options[:num] if options[:num]

          near_query["maxDistance"]  = options[:max_distance] if options[:max_distance]

          near_query["query"]               = options[:query] if options[:query]

          # works in mongodb 1.7 but still in beta and not supported by mongodb
          if Mongoid::Geo.mongo_db_version >= 1.7
            near_query["spherical"]  = options[:spherical] if options[:spherical]

            # mongodb < 1.7 returns degrees but with earth flat. in Mongodb 1.7 you can set sphere and let mongodb calculate the distance in Miles or KM
            # for mongodb < 1.7 we need to run Haversine first before calculating degrees to Km or Miles. See below.
            if options[:distance_multiplier]
              near_query["distanceMultiplier"] = options[:distance_multiplier]
            elsif options[:unit]
              near_query["distanceMultiplier"] = Mongoid::Geo::Unit.distMultiplier(options[:unit]) 
            end
          end
        end
      end

      def query_result klass, query, center, location_attribute, options = {}  
        results = klass.db.command(query) # raw query
        results = (results['results'].kind_of?(Array)&& results['results'].size > 0) ? results['results'].map do |qr|
          hash = qr['obj'].to_hash
          res = klass.instantiate(hash) # loading up data from db with parsing
          res.new_record = false # not new record at all.
          res.from_point = qr['fromPoint'] # camel case is awkward in ruby when using variables...
          res.from_hash = qr['fromHash']
          res.distance = (Mongoid::Geo.mongo_db_version >= 1.7) ? qr['dis'] : calc_distance(qr, center, location_attribute, options)
          res._id = qr['obj']['_id'].to_s
          res
        end : []
        results
      end

      private

      def calc_distance r, center, location_attribute, options     
        distanceMultiplier = distance_multiplier(options)
        loc     = location_attribute.to_s.split('.').inject(r['obj']) { |node,attribute| node[attribute] }.extend(Mongoid::Geo::Point).to_points

        center  = center.extend(Mongoid::Geo::Point).to_points
        dist    = Mongoid::Geo::Haversine.distance(center.first, center.last, loc.first, loc.last) 
        dist    *= distanceMultiplier if distanceMultiplier
        dist
      end
    end
  end
end
