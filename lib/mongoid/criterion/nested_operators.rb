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

      # inherited
      # def to_mongo_query v        
      # end

      def hash
        [@op_a, [@op_b, @key]].hash
      end
      
      protected

      def query(v) 
        center? ? circle_query(v) : box_query(v)
      end

      def center?
        inner_operator =~ /center/
      end

      def box?
        inner_operator =~ /box/
      end

      def circle_query(v)
        Mongoid::Geo::CircleQuery.new(v)
      end

      def box_query(v)
        Mongoid::Geo::BoxQuery.new(v)
      end

      private
      
      def outer_operator
        op_a
      end

      def inner_operator
        op_b
      end      
    end
  end
end
