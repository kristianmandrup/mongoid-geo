module Mongoid
  module Geo
    class Haversine
      # Haversine Formula
      # Adapted from Geokit Gem
      # https://github.com/andre/geokit-gem.git
      # By: Andre Lewis
      PI_DIV_RAD = 0.0174
      KMS_PER_MILE = 1.609
      EARTH_RADIUS_IN_MILES = 3963.19
      EARTH_RADIUS_IN_KMS = EARTH_RADIUS_IN_MILES * KMS_PER_MILE
      MILES_PER_LATITUDE_DEGREE = 69.1
      KMS_PER_LATITUDE_DEGREE = MILES_PER_LATITUDE_DEGREE * KMS_PER_MILE
      LATITUDE_DEGREES = EARTH_RADIUS_IN_MILES / MILES_PER_LATITUDE_DEGREE

      def self.distance(lat1, lng1, lat2, lng2)
        from = {:lat => lat1, :lng => lng1}
        to = {:lat => lat2, :lng => lng2}

        return 0.0 if from == to #return 0.0 if points are have the same coordinates

        units = Mongoid::Geo.default_units
        formula = Mongoid::Geo.distance_formula

        case formula
          when :spherical
            begin
              units_sphere_multiplier(units) * 
              Math.acos( 
                Math.sin(degrees_to_radians(from[:lat])) * Math.sin(degrees_to_radians(to[:lat])) + 
                Math.cos(degrees_to_radians(from[:lat])) * Math.cos(degrees_to_radians(to[:lat])) * 
                Math.cos(degrees_to_radians(to[:lng]) - degrees_to_radians(from[:lng]))
              )
            rescue Errno::EDOM
              0.0
            end
          when :flat
            Math.sqrt(
              (units_per_latitude_degree(units) * (from[:lat] - to[:lat]))**2 +
              (units_per_longitude_degree(from[:lat], units) * (from[:lng] - to[:lng]))**2
            )
        end
      end

      def self.degrees_to_radians(degrees)
        degrees.to_f / 180.0 * Math::PI
      end

      def self.units_sphere_multiplier(units)
        case units
          when :km
            EARTH_RADIUS_IN_KMS
          when :miles
            EARTH_RADIUS_IN_MILES
        end
      end

      def self.units_per_latitude_degree(units)
        case units
          when :km
            KMS_PER_LATITUDE_DEGREE
          when :miles
            MS_PER_LATITUDE_DEGREE
        end
      end

      def self.units_per_longitude_degree(lat, units)
        miles_per_longitude_degree = (LATITUDE_DEGREES * Math.cos(lat * PI_DIV_RAD)).abs
        case units
          when :kms
            miles_per_longitude_degree * KMS_PER_MILE
          when :miles
            miles_per_longitude_degree
        end
      end

    end
  end
end
