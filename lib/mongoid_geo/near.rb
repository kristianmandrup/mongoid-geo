#require 'net/http'
require 'active_support'
require 'hashie'
require 'mongoid_geo/haversine'

module Mongoid
  module Geo
    class << self

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
      def geoNear(center, location_attribute, options = {})
        center = center.respond_to?(:collection) ? eval("center.#{location_attribute}") : center
        query = create_query(self, center, options)
        query_result(self, query, center, location_attribute, options)
      end

      alias_method :geo_near, :geoNear

      protected

      def create_query klass, center, options = {}
        nq = BSON::OrderedHash.new.tap do |near_query|
          near_query["geoNear"] = klass.to_s.tableize
          near_query["near"] = center
          near_query["num"] = options[:num] if options[:num]
          near_query["maxDistance"] = options[:maxDistance] if options[:maxDistance]

          # mongodb < 1.7 returns degrees but with earth flat. in Mongodb 1.7 you can set sphere and let mongodb calculate the distance in Miles or KM
          # for mongodb < 1.7 we need to run Haversine first before calculating degrees to Km or Miles. See below.
          near_query["distanceMultiplier"] = distance_multiplier(options)
          near_query["query"] = options[:query] if options[:query]

          # works in mongodb 1.7 but still in beta and not supported by mongodb
          near_query["spherical"] = (options[:spherical] && Mongoid::Geo.mongo_db_version >= 1.7)
        end
        nq
      end

      def query_result klass, query, center, location_attribute, options = {}
        results = exec_query(klass, query)
        ids = []
        results = (results['results'].kind_of?(Array)&& results['results'].size > 0) ? results['results'].map do |qr|
          hash = qr['obj'].to_hash
          res = klass.instantiate(hash)
          ids << res.id
          res.fromPoint = qr['fromPoint']
          res.fromHash = qr['fromHash']
          res.distance = (Mongoid::Geo.mongo_db_version >= 1.7) ? qr['dis'] : calc_distance(qr, center, location_attribute, options)
          res._id = qr['obj']['_id'].to_s
          res.new_record = false
          res
        end : []
        Mongoid::Criteria.new(klass).where(:_id.in => ids)
        results
      end

      private

      def distance_multiplier options
        distanceMultiplier = options[:distanceMultiplier]
        return distanceMultiplier if distanceMultiplier && Mongoid::Geo.mongo_db_version >= 1.7
        return Mongoid::Geo::Unit.distMultiplier(options[:unit]) if options[:unit]
        1
      end

      def exec_query klass, query
        klass.collection.db.command(query)
      end

      def calc_distance r, center, location_attribute, options
        distanceMultiplier = distance_multiplier(options)
        loc = location_attribute.to_s.split('.').inject(r['obj']) { |node, attribute| node[attribute] }.extend(Mongoid::Geo::Point).to_points

        center = center.extend(Mongoid::Geo::Point).to_points
        dist = Mongoid::Geo::Haversine.distance(center.first, center.last, loc.first, loc.last)
        dist *= distanceMultiplier if distanceMultiplier
        dist
      end
    end

  end
end
