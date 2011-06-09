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

      # this is called by CriteriaHelpers#expand_complex_criteria in order to generate
      # the command hash sent to the mongo DB to be executed
      # depending on whether the operator is some kind of box or center command, the
      # operator will point to a different type of array  
      def make_hash v                               
        points = circle? ? circle(v) : box(v)        
        {"$#{outer_op}" => {"$#{operator}" => points.to_a } }
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

      def circle?
        operator =~ /center/
      end

      def box?
        operator =~ /box/
      end

      def circle(v)
        Mongoid::Geo::Shapes::Circle.new(v)
      end

      def box(v)
        Mongoid::Geo::Shapes::Box.new(v)
      end
    end
  end
end
