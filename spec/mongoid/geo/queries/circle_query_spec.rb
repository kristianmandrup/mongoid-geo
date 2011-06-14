require "mongoid/geo/spec_helper"

def circle_query_class
  Mongoid::Geo::CircleQuery
end

describe circle_query_class do
  let(:center) { [1,1] }

  let(:hash_circle) do               
    circle_query_class.new :center => center, :radius => 5
  end
  
  let(:array_circle) do
    circle_query_class.new [ center, 5 ]
  end
  
  describe '#to_a' do
    describe 'hash :lower_left, :upper_right' do
      it 'should convert to array of points' do
        hash_circle.to_a.should == [ center, 5]
      end
    end

    describe 'array of 2 sub-arrays' do
      it 'should convert to array of points' do
        array_circle.to_a.should == [ center, 5 ] # not sure this is correct?
      end
    end
  end

  describe '#to_query' do
    describe ':within :center' do
      it 'should return mongo query hash' do      
        op_a, op_b = :within, :center
        hash_circle.to_query(op_a, op_b).should == {"$#{op_a}" => {"$#{op_b}" => hash_circle.to_a } }
      end
    end
  end
end