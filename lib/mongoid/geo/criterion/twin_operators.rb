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
        v = extract_nearMax(v) if !v.kind_of?(Array) && op_b =~ /max/i
        {"$#{op_a}" => to_points(v.first), "$#{op_b}" => to_points(v.last) }
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
      
      def to_points v
        return v if v.kind_of? Fixnum 
        v.extend(Mongoid::Geo::Point).to_points
      end

      def extract_nearMax(v)
        case v
        when Hash
          [v[:point], v[:distance]]
        else
          v.respond_to?(:point) ? [v.point, v.distance] : raise("Can't extract nearMax values from: #{v}, must have :point and :maxDistance methods or equivalent hash keys in Hash")
        end
      end
      
    end
  end
end
