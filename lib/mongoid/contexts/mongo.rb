module Mongoid #:nodoc:
  module Contexts #:nodoc:
    class Mongo
      def geo_near(center, location_attribute, args = {})
        Mongoid::Geo.config do |c|
          c.server_version ||= klass.connection.server_version
        end

        center = (center.respond_to?(location_attribute)) ? center.send(location_attribute) : center

        # minimum query
        query = {
          :geoNear  => klass.to_s.tableize,
          :near     => center, 
        }
        
        # optional query fields
        query[:num]           = options[:limit] if options[:limit]
        query[:num]           = args[:num].to_i if args[:num]
        query[:maxDistance]   = args[:max_distance] if args[:max_distance]
        query[:query]         = selector
        query[:query]         = selector.merge(args[:query]) if args[:query]

        if klass.connection.server_version >= 1.7          
          query["spherical"]  = args[:spherical] if args[:spherical]

          # mongodb < 1.7 returns degrees but with earth flat. in Mongodb 1.7 you can set sphere and let mongodb calculate the distance in Miles or KM
          # for mongodb < 1.7 we need to run Haversine first before calculating degrees to Km or Miles. See below.
          if args[:distance_multiplier]
            query["distanceMultiplier"] = args[:distance_multiplier]
          elsif args[:unit]
            query["distanceMultiplier"] = Mongoid::Geo::Unit.distance_multiplier(args[:unit]) 
          end
        end
        results = klass.db.command(query)
        if results['results'].kind_of?(Array) && results['results'].size > 0
          results['results'].collect do |result|
            res = Mongoid::Factory.from_db(klass, result['obj'])

            # camel case is awkward in ruby when using variables...
            res.from_point = result['fromPoint'] || center
            res.from_hash = result['fromHash'] if result['fromHash']
            if klass.connection.server_version >= 1.7
              res.distance = result['dis']
            else
              dist_options = {}
              dist_options.merge!(:units => args[:units]) if args[:units]
              dist_options.merge!(:formula => args[:formula]) if args[:formula]
              res.distance = Mongoid::Geo::Formula::Haversine.distance(center[1], center[0], loc[1], loc[0], dist_options)
            end
            res
          end
        else
          []
        end
      end
    end
  end
end
