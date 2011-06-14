module Mongoid
  module Geo
    module Config 
      class << self
        attr_accessor :server_version

        def enable_extensions! *names
          names = names.flatten.uniq
          names = supported_extensions if names == [:all]
          names.each {|name| enable_extension! name }
        end

        def enable_extension! name
          case name.to_sym
          when :geo_point
            require 'mongoid/geo/extensions/geo_point'
          when :geo_vectors, :geo_vector
            require 'mongoid/geo/extensions/geo_vectors'
            require 'mongoid/geo/extensions/geo_point'
          end
        end
        
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

        def server_version
          @server_version ||= 1.8
        end

        def coord_mode
          @coord_mode ||= default_coord_mode
        end          

        def coord_mode= coord_mode
          raise "Coordinate mode must be one of: #{supported_coord_modes}, was: #{coord_mode}" unless supported_coord_modes.include?(coord_mode)
          @coord_mode = coord_mode
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