module Mongoid
  module Geo
    module Config 
      class << self
        attr_accessor :server_version

        def server_version
          @server_version ||= 1.8
        end

        def coord_mode
          @coord_mode ||= default_coord_mode
        end          

        def coord_mode= coord_mode
          raise "Input mode must be one of: #{supported_coord_modes}, was: #{coord_mode}" unless supported_coord_modes.include?(coord_mode)
          @coord_mode = mode
        end
        
        def distance_formula
          @default_distance_formula ||= default_distance_formula
        end          
        
        def distance_formula= distance_formula 
          raise "Default distance formula must be one of: #{supported_formulas}, was: #{distance_formula}" unless formulas.include?(distance_formula)
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

        def default_units
          :kms
        end
   
        def default_coord_mode
          :lng_lat
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

        def supported_coord_modes
          [:lat_lng, :lng_lat]
        end        
      end
    end
  end
end