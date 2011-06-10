# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    # Complex criterion are used when performing operations on symbols to get
    # get a shorthand syntax for where clauses.
    #
    # Example:
    
    # {:outer_operator => 'within', :operator => 'center' }
    # { :location => { "$within" => { "$center" => [ [ 50, -40 ], 1 ] } } }
    class NestedOperators < TwinOperators
      # Create the new complex criterion.
      def initialize(opts = {})
        super
      end

      # called by CriteriaHelpers#expand_complex_criteria in order to generate
      # the command hash sent to the mongo DB to be executed
      # Determines if the operator is some kind of 'box' or 'center' command
      # Rhe operator will use a different type of array for each command type
      def to_query v        
        shape(v).to_query(op_a, op_b)
      end

      def hash
        [@op_a, [@op_b, @key]].hash
      end
      
      protected

      def shape(v) 
        center? ? circle(v) : box(v)
      end

      def center?
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
