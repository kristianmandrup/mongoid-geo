module Mongoid
  module Geo
    class Haversine
      RADIAN_PER_DEGREE = Math::PI / 180.0

      def self.distance(lat1, lng1, lat2, lng2)
        lat1_radians = lat1 * RADIAN_PER_DEGREE
        lat2_radians = lat2 * RADIAN_PER_DEGREE

        distance_lat = (lat2-lat1) * RADIAN_PER_DEGREE
        distance_lng = (lng2-lng1) * RADIAN_PER_DEGREE

        a = Math.sin(distance_lat/2)**2 + Math.cos(lat1_radians) * Math.cos(lat2_radians) * Math.sin(distance_lng/2) ** 2
        2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      end
    end
  end
end
