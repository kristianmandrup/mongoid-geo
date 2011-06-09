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
          raise "method nearSphere only works on mongoDB version 1.7 or above" if Mongoid::Geo.mongo_db_version < 1.7
          Criterion::Complex.new(:operator => 'nearSphere', :key => self)          
        end

        def near_max calc = :flat
          Criterion::TwinOperators.new(:op_a => get_op(calc, 'near'), :op_b =>'maxDistance', :key => self)            
        end

        def within_box
          Criterion::OuterOperator.new(:outer_op => 'within', :operator => 'box', :key => self)
        end

        def within_center calc = :flat
          Criterion::OuterOperator.new(:outer_op => 'within', :operator => get_op(calc, 'center'), :key => self)
        end 
        
        private
        
        def get_op calc, operator
          if calc.to_sym == :sphere
            raise "method #{operator}Sphere only works on mongoDB version 1.7 or above" if Mongoid::Geo.mongo_db_version < 1.7
            "#{operator}Sphere"
          else
            operator
          end
        end
      end
    end
  end
end
