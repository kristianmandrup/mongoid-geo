module Mongoid
  module Geo
    module Config 
      class << self
        def radian_multiplier
          {
            :feet => 364491.8,
            :meters => 111170,
            :kms => 111.17,
            :miles => 69.407,
            :radians => 1
          }
        end

        def distance_calculator
          @distance_calculator ||= default_distance_calculator
        end

        def distance_calculator= clazz
          raise "Distance calculator must be a Class with a class method called #distance" unless clazz.kind_of?(Module) && clazz.respond_to?(:distance)
          @distance_calculator = clazz
        end

        def distance_formula
          @distance_formula ||= default_distance_formula
        end          
        
        def distance_formula= distance_formula 
          raise "Default distance formula must be one of: #{supported_distance_formulas}, was: #{distance_formula}" unless supported_distance_formulas.include?(distance_formula)
          @distance_formula = distance_formula 
        end

        def units
          @units ||= default_units
        end          
        
        def units= units
          raise "Default units must be one of: #{supported_units}, was: #{units}" unless supported_units.include?(units)
          @units = units 
        end
      
        protected

        def default_distance_calculator
          require 'haversine'
          Haversine
        end

        def default_units
          :kms
        end
   
        def default_distance_formula
          :sphere
        end
        
        def supported_distance_formulas
          [:flat, :sphere]
        end
        
        def supported_units
          [:kms, :miles]
        end        
      
      end
    end
  end
end
