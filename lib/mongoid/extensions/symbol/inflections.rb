# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Symbol #:nodoc:
      module Inflections #:nodoc:
        
        # $nearSphere $centerSphere        
        # near_max
        # - { $near : [50,50] , $maxDistance : 5 }
        # within_box
        # - {"$within" : {"$box" : box}
        # within_center
        # - {"$within" : {"$center" : [center, radius]}}})          

        def near_sphere
          Criterion::Complex.new(:operator => get_op(calc, 'near'), :key => self)          
        end

        def near_max calc = :flat
          twin_operators(:op_a => get_op(calc, 'near'), :op_b =>'maxDistance', :key => self)            
        end

        def within_box
          nested_operators(:op_a => 'within', :op_b => 'box', :key => self)
        end

        def within_center calc = :flat
          nested_operators(:op_a  => 'within', :op_b => get_op(calc, 'center'), :key => self)
        end 
        
        private

        def twin_operators options
          Criterion::TwinOperators.new options
        end

        def nested_operators options
          Criterion::NestedOperators.new options
        end
        
        def get_op calc, operator
          if calc.to_sym == :sphere && Mongoid.master.connection.server_version >= '1.7'
            "#{operator}Sphere"
          else
            operator
          end
        end
      end
    end
  end
end
