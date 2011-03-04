require 'net/http'
require 'active_support'
require 'hashie'
require 'mongoid/geo/haversine'

module Mongoid
  module Geo
    module Distance      
      attr_reader :distance
      
      def set_distance dist
        @distance = dist
      end
    end
    
    module Model
      def to_model
        m = clazz.where(:_id => _id).first.extend(Mongoid::Geo::Distance)
        m.set_distance distance
        m
      end
    end
    
    module Models
      def to_models
        clazz = first.clazz
        ids = map(&:_id)
        distances = map(&:distance)
        i = 0
        clazz.where(:_id.in => ids).to_a.map do |m| 
          m.extend(Mongoid::Geo::Distance)
          m.set_distance distances[i]
          i += 1
          m
        end
      end
    end
    
    module Near
      def geoNear(center, location_attribute, options = {})
        center = center.respond_to?(:collection) ? center.send(location_attribute) : center
        query = create_query(self, center, options)
        create_result(query_result(self, query, center, location_attribute)).extend(Mongoid::Geo::Models)
      end

      protected
    
      def create_query clazz, center, options = {}
        num                 = options[:num]
        maxDistance         = options[:maxDistance]
        query               = options[:query]
        distanceMultiplier  = options[:distanceMultiplier]        
        mode                = options[:mode] || :plane

        nq = BSON::OrderedHash.new.tap do |near_query|
          near_query["geoNear"]      = clazz.to_s.tableize
          near_query["near"]         = center
          near_query["num"]          = num if num
          near_query["maxDistance"]  = maxDistance if maxDistance
          near_query["distanceMultiplier"]  = distanceMultiplier if distanceMultiplier
          near_query["query"]        = query if query

          # works in mongodb 1.7 but still in beta and not supported by mongodb
          near_query["spherical"]  = true if mode == :sphere
        end
        nq
      end      

      def query_result clazz, query, center, location_attribute
        lon,lat = center    
        query_result = clazz.collection.db.command(query)['results'].sort_by do |r|
          loc = r['obj'][location_attribute.to_s]
          r['distance'] = Mongoid::Geo::Haversine.distance(lat, lon, loc[1], loc[0])
          r['clazz'] = clazz
        end
      end

      def create_result query_result
        query_result.inject([]) do |result, qr|
          res = Hashie::Mash.new(qr['obj'].to_hash).extend(Mongoid::Geo::Model)
          res.clazz = qr['clazz']
          res.distance = qr['distance']
          res._id = qr['obj']['_id'].to_s
          result.push(res)
        end
      end    
    end  
  end
end