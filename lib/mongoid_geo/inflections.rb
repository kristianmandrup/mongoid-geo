# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Symbol #:nodoc:
      module Inflections #:nodoc:
        
        # $nearSphere $centerSphere        
        # nearMax
        # - { $near : [50,50] , $maxDistance : 5 }
        # withinBox
        # - {"$within" : {"$box" : box}
        # withinCenter
        # - {"$within" : {"$center" : [center, radius]}}})          

        def geoNear
          Criterion::Complex.new(:operator => 'geoNearSphere', :key => self)          
        end

        def nearSphere
          Mongoid::Geo.spherical_mode do
            Criterion::Complex.new(:operator => 'nearSphere', :key => self)          
          end
        end

        def nearMax *calcs
          calcs = (!calcs || calcs.empty?) ? [:flat] : calcs
          case calcs.size
          when 1
            Criterion::TwinOperators.new(:op_a => get_op(calcs.first, 'near'), :op_b => get_op(calcs.first, 'maxDistance'), :key => self)
          when 2
            Criterion::TwinOperators.new(:op_a => get_op(calcs.first, 'near'), :op_b => get_op(calcs.last, 'maxDistance'), :key => self)            
          else
            raise "method nearMax takes one or two symbols as arguments, each symbol must be either :flat or :sphere"
          end
        end

        def withinBox calc = :flat
          Criterion::OuterOperator.new(:outer_op => 'within', :operator => get_op(calc, 'box'), :key => self)
        end

        def withinCenter calc = :flat
          Criterion::OuterOperator.new(:outer_op => 'within', :operator => get_op(calc, 'center'), :key => self)
        end 
        
        private
        
        def get_op calc, operator
          calc.to_s == 'sphere' ? "#{operator}Sphere" : operator
        end
      end
    end
  end
end