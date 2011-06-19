module Mongoid #:nodoc:
  module Contexts #:nodoc:
    class Mongo
      def geo_near(center, args = {})
        # minimum query
        query = {
          :geoNear  => klass.to_s.tableize,
          :near     => center, 
        }
        query[:maxDistance]   = args[:max_distance] if args[:max_distance]
        
        # account for skip
        if args[:num] 
          query[:num]         = args[:num].to_i          
        elsif self.options[:limit].kind_of?(Numeric) && self.options[:limit] > 0
          query[:num]         = (self.options[:skip] || 0) + self.options[:limit]
        end
        

        if args[:query]
          query[:query]         = args[:query]
        elsif self.selector != {}
          query[:query]         = self.selector
        end

        if klass.db.connection.server_version >= '1.7'          
          query["spherical"]  = true if args[:spherical]

          # mongodb < 1.7 returns degrees but with earth flat. in Mongodb 1.7 you can set sphere and let mongodb calculate the distance in Miles or KM
          # for mongodb < 1.7 we need to run Haversine first before calculating degrees to Km or Miles. See below.
          if args[:distance_multiplier]
            query["distanceMultiplier"] = args[:distance_multiplier]
          elsif args[:unit]
            query["distanceMultiplier"] = Mongoid::Geo::Config.radian_multiplier(args[:unit])
          end
        end
        results = klass.db.command(query)
        if results['results'].kind_of?(Array) && results['results'].size > 0
          rows = results['results'].collect do |result|
            res = Mongoid::Factory.from_db(klass, result['obj'])

            # camel case is awkward in ruby when using variables...
            res.from_point = result['fromPoint'] || center
            res.from_hash = result['fromHash'] if result['fromHash']
            if klass.db.connection.server_version >= '1.7'
              res.distance = result['dis'].to_f
            else
              dist_options = {}
              dist_options[:units] = args[:units] if args[:units]
              dist_options[:formula] = args[:formula] if args[:formula]
              # TODO: Should find and use the first field marked as :geo
              loc = res.location              
              res.distance = Mongoid::Geo::Config.distance_calculator.distance(center[1], center[0], loc[1], loc[0]) # , dist_options
            end
            res
          end
        else
          rows = []
        end
        if self.options[:skip] && rows.size > self.options[:skip]
          rows[self.options[:skip]..rows.size-1]
        else
          rows
        end
      end
    end
  end
end
