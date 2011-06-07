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

        def nearSphere
          raise "method nearSphere only works on mongoDB version 1.7 or above" if Mongoid::Geo.mongo_db_version < 1.7
          Criterion::Complex.new(:operator => 'nearSphere', :key => self)          
        end
        alias_method :near_sphere, :nearSphere

        def nearMax calc = :flat
          Criterion::TwinOperators.new(:op_a => get_op(calc, 'near'), :op_b =>'maxDistance', :key => self)            
        end
        alias_method :near_max, :nearMax

        def withinBox
          Criterion::OuterOperator.new(:outer_op => 'within', :operator => 'box', :key => self)
        end
        alias_method :within_box, :withinBox

        def withinCenter calc = :flat
          Criterion::OuterOperator.new(:outer_op => 'within', :operator => get_op(calc, 'center'), :key => self)
        end 
        alias_method :within_center, :withinCenter
        
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
