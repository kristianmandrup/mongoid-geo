module Mongoid
  module Geo
    class Unit
      class << self
        def key unit = :km
          unit = unit.to_sym
          methods.grep(/_unit/).each do |meth|
            return meth.to_s.chomp('_unit').to_sym if send(meth).include? unit
          end
          raise ArgumentError, "Unknown unit key: #{unit}"
        end

        def distMultiplier unit = :km
          unit_key = key(unit)
          return radian_multiplier[unit_key] if unit_key && Mongoid::Geo.mongo_db_version >= 1.7      
          unit_multiplier[unit_key] if unit_key
        end

        def precision
          {
            :feet => 0,
            :meters => 2,
            :kms => 4,
            :miles => 4,
            :radians => 4
          }
        end

        # from mongoid-geo, as suggested by niedhui :)
        def radian_multiplier
          { 
            :feet => 364491.8,
            :meters => 111170,
            :kms => 111.17,
            :miles => 69.407,
            :radians => 1
          }
        end

        def unit_multiplier
          {
            :feet => 0.305,
            :meters => 1,
            :kms => 6371,
            :miles => 3959
          }
        end

        def meters_map
          {
           :feet => 3.2808,
           :meters => 1,
           :kms => 0.001,
           :miles => 0.00062137,
           :radians => 111170
          }
        end
      
        protected

        def feet_unit 
          [:ft, :feet, :foot]
        end
      
        def meters_unit 
          [:m, :meter, :meters]
        end

        def kms_unit 
          [:km, :kms, :kilometer, :kilometers]
        end

        def miles_unit 
          [:mil, :mile, :miles]
        end

        def radians_unit 
          [:rad, :radians]
        end
      end
    end
  end
end