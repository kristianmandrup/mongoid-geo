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
        {"$#{outer_op}" => {"$#{operator}" => {v}}
      end

      def hash
        [@outer_op, [@operator, @key].hash
      end

      def eql?(other)
        self == (other)
      end

      def ==(other)
        return false unless other.is_a?(self.class)        
        self.outer_op == other.outer_op && self.key == other.key && self.operator == other.operator
      end
    end
  end
end
