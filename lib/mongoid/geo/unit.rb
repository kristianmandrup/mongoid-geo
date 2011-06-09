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

        def radian_multiplier unit = :km
          radian_multiplier[key(unit)]
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