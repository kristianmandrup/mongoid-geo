#require 'net/http'
require 'active_support'
require 'hashie'
require 'mongoid/geo/haversine'

module Mongoid
  module Geo
    class << self
      attr_accessor :mongo_db_version
      attr_accessor :spherical
      
      def spherical_mode mode = true, &block
        @spherical = mode
        yield if block
        @spherical = !mode
      end
      
      def lat_index
        @spherical ? 1 : 0
      end

      def lng_index
        @spherical ? 0 : 1
      end
    end

    module Distance
      attr_reader :distance

      def set_distance dist
        @distance = dist
      end
    end

    module Model
      def to_model
        m = klass.where(:_id => _id).first.extend(Mongoid::Geo::Distance)
        m.set_distance distance
        m
      end
    end

    module Models
      def to_models
        distance_hash = Hash[ self.map {|item| [item._id, item.distance] } ]

        ret = to_criteria.to_a.map do |m|
          m.extend(Mongoid::Geo::Distance)
          m.set_distance distance_hash[m._id.to_s]
          m
        end

        ret.sort {|a,b| a.distance <=> b.distance}
      end
      
      def to_criteria
        ids = map(&:_id)
        first.klass.where(:_id.in => ids)
      end
    end

    module Near
      def geoNear(center, location_attribute, options = {})
        center = center.respond_to?(:collection) ? center.send(location_attribute) : center
        query = create_query(self, center, options)
        create_result(query_result(self, query, center, location_attribute, options)).extend(Mongoid::Geo::Models)
      end

      protected

      def create_query klass, center, options = {}
        num                 = options[:num]
        maxDistance         = options[:maxDistance]
        query               = options[:query]        
        mode                = options[:mode] || :plane

        nq = BSON::OrderedHash.new.tap do |near_query|
          near_query["geoNear"]      = klass.to_s.tableize
          near_query["near"]         = center
          near_query["num"]          = num if num
          near_query["maxDistance"]  = maxDistance if maxDistance

          # mongodb < 1.7 returns degrees but with earth flat. in Mongodb 1.7 you can set sphere and let mongodb calculate the distance in Miles or KM
          # for mongodb < 1.7 we need to run Haversine first before calculating degrees to Km or Miles. See below.
          near_query["distanceMultiplier"]  = distance_multiplier(options)
          near_query["query"]               = query if query

          # works in mongodb 1.7 but still in beta and not supported by mongodb
          near_query["spherical"]  = true if mode == :sphere && Mongoid::Geo.mongo_db_version >= 1.7
        end
        nq
      end

      def query_result klass, query, center, location_attribute, options = {}        
        query_result = query_results(klass, query).sort_by do |r|          
          # Calculate distance in KM or Miles if mongodb < 1.7
          r[distance_meth] ||= calc_distance(r, center, location_attribute, options) if Mongoid::Geo.mongo_db_version < 1.7
          r['klass'] = klass
        end
        query_result
      end

      def create_result qres
        qres.map do |qr|
          res = Hashie::Mash.new(qr['obj'].to_hash).extend(Mongoid::Geo::Model)
          res.klass = qr['klass']
          res.distance = qr[distance_meth]
          res._id = qr['obj']['_id'].to_s
          res
        end
      end
      
      private

      def distance_multiplier options
        distanceMultiplier  = options[:distanceMultiplier]
        return distanceMultiplier if distanceMultiplier && Mongoid::Geo.mongo_db_version >= 1.7
        return unit_multiplier[options[:unit]] if options[:unit]        
      end

      def unit_multiplier
        {
          :feet => 0.305,
          :ft => 0.305,
          :m => 1,
          :meters => 1,
          :km => 6371,
          :m => 3959,
          :miles => 3959
        }
      end
      
      def query_results klass, query 
        exec_query(klass, query)['results']
      end

      def exec_query klass, query
        klass.collection.db.command(query)
      end

      def calc_distance r, center, location_attribute, options
        distanceMultiplier  = distance_multiplier(options)
        loc   = r['obj'][location_attribute.to_s].to_geopoint
        center = center.to_geopoint
        dist  = Mongoid::Geo::Haversine.distance(center.lat, center.lng, loc.lat, loc.lng)
        dist  = dist * distanceMultiplier if distanceMultiplier
      end
      
      def distance_meth
        Mongoid::Geo.mongo_db_version >= 1.7 ? 'dis' : 'distance'
      end
    end
  end
end