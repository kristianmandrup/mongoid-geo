module Mongoid
  module Geo
    class Unit
      class << self
        def radian_multiplier unit = :km
          raise ArgumentError, "Unknown unit key: #{unit}" if !supported_unit? unit
          radian_multiplier[unit.to_sym]
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

        def supported_unit? unit
          supported_units.include? unit.to_sym          
        end

        def supported_units
          [:feet, :meters, :kms, :miles, :radians]
        end
      end
    end
  end
end