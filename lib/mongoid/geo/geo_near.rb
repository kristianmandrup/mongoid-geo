require 'net/http'
require 'active_support'
require 'haversine'
require 'rack'
require 'hashie'
require 'mongoid/geo/haversine'

module Mongoid
  module Geo
    module Near
      def geoNear(center, location_attribute)
        center = center.respond_to?(:collection) ? center.send(location_attribute) : center
        query = create_query(self, center)
        create_result(query_result(self, query, center, location_attribute))
      end

      protected
    
      def create_query clazz, center, mode = :plane
        BSON::OrderedHash.new.tap do |query|
          query["geoNear"]    = clazz.to_s.tableize
          query["near"]       = center
          # works in mongodb 1.7 but still in beta and not supported by mongodb
          query["spherical"]  = true if mode == :sphere
        end
      end      

      def query_result clazz, query, center, location_attribute
        lon,lat = center    
        query_result = clazz.collection.db.command(query)['results'].sort_by do |r|
          loc = r['obj'][location_attribute.to_s]
          r['distance'] = Mongoid::Geo::Haversine.distance(lat, lon, loc[1], loc[0])
        end
      end

      def create_result query_result
        query_result.inject([]) do |result, qr|
          res = Hashie::Mash.new(qr['obj'].to_hash)
          res.dis = qr['distance']
          res._id = qr['obj']['_id'].to_s
          result.push(res)
        end
      end    
    end  
  end
end