# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    # Complex criterion are used when performing operations on symbols to get
    # get a shorthand syntax for where clauses.
    #
    # Example:
    
    # {:opA => 'near', :opB => 'maxDistance' }
    # :location => { $near => [50,50], $maxDistance => 5 }
    class TwinOperators
      attr_accessor :key, :op_a, :op_b

      # Create the new complex criterion.
      def initialize(opts = {})
        @key = opts[:key]
        @op_a = opts[:op_a]
        @op_b = opts[:op_b]        
      end

      def make_hash v     
        v = distance(v).to_a if max?
        {"$#{op_a}" => to_point(v.first), "$#{op_b}" => to_point(v.last) }
      end

      def hash
        [@op_a, @op_b, @key].hash
      end

      def eql?(other)
        self == (other)
      end

      def ==(other)
        return false unless other.is_a?(self.class)        
        self.op_a == other.op_a && self.op_b == other.op_b && self.key == other.key 
      end
            
      protected

      def max?
        op_b =~ /max/i
      end

      def distance(v)
        Mongoid::Geo::Shapes::Distance.new(v)
      end
    end
  end
end
