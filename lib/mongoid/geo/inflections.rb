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

        def near calc
          Criterion::Complex.new(:operator => get_op(calc, 'near'), :key => self)          
        end

        def nearMax calc
          Criterion::TwinOperators.new(:op_a => get_op(calc, 'near'), :op_b => get_op(calc, 'maxDistance'), :key => self)
        end

        def withinBox calc
          Criterion::InnerKey.new(:outer_op => 'within', :operator => get_op(calc, 'box'), :key => self)
        end

        def withinCenter calc
          Criterion::InnerKey.new(:outer_operator => 'within', :operator => get_op(calc, 'center'), :key => self)
        end 
        
        private
        
        def get_op calc, operator
          calc.to_s == 'sphere' ? "#{operator}Sphere" : operator
        end
      end
    end
  end
end