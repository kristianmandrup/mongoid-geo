# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    # Complex criterion are used when performing operations on symbols to get
    # get a shorthand syntax for where clauses.
    #
    # Example:
    
    # {:outer_operator => 'within', :operator => 'center' }
    # { :location => { "$within" => { "$center" => [ [ 50, -40 ], 1 ] } } }
    class OuterOperator
      attr_accessor :key, :outer_op, :operator

      # Create the new complex criterion.
      def initialize(opts = {})
        @key = opts[:key]
        @operator = opts[:operator]
        @outer_op = opts[:outer_op]        
      end

      def make_hash v                               
        if operator =~ /box/
          v = extract_box(v) if !v.kind_of?(Array)
          v = [to_points(v.first), to_points(v.last)]
        end
        
        v = extract_circle(v) if !v.kind_of?(Array) && operator =~ /center/
        {"$#{outer_op}" => {"$#{operator}" => to_points(v) } }
      end

      def hash
        [@outer_op, [@operator, @key]].hash
      end

      def eql?(other)
        self == (other)
      end

      def ==(other)
        return false unless other.is_a?(self.class)        
        self.outer_op == other.outer_op && self.key == other.key && self.operator == other.operator
      end
      
      protected

      def to_points v
        v.extend(Mongoid::Geo::Point).to_points
      end

      def extract_circle(v)
        case v
        when Hash
          [v[:center], v[:radius]]
        else
          v.respond_to?(:center) ? [v.center, v.radius] : raise("Can't extract box from: #{v}, must have :center and :radius methods or equivalent hash keys in Hash")
        end
      end
      
      def extract_box v
        box = case v
        when Hash
          [v[:lower_left], v[:upper_right]]
        else
          v.respond_to?(:lower_left) ? [v.lower_left, v.upper_right] : raise("Can't extract box from: #{v}, must have :lower_left and :upper_right methods or equivalent hash keys in Hash")
        end        
      end
    end
  end
end
