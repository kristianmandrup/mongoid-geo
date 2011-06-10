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

      def to_query v        
        shape(v).to_query(op_a, op_b)        
      end

      def hash
        [@op_a, @op_b, @key].hash
      end

      def eql?(other)
        self == (other)
      end

      def ==(other)
        return false unless other.is_a?(self.class)        
        # self.op_a == other.op_a && self.op_b == other.op_b && self.key == other.key 
        compare(other, :op_a, :op_b, :key)        
      end
            
      protected

      def compare(other, *methods)
        methods.all? {|meth| self.send(meth) == other.send(meth) }         
      end

      def shape(v) 
        return distance(v) if max?
      end

      def max?
        op_b =~ /max/i
      end

      def distance(v)
        Mongoid::Geo::Shapes::Distance.new(v)
      end
    end
  end
end
