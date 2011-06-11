require "mongoid/spec_helper"

def circle_class
  Mongoid::Geo::Shapes::Circle
end

describe circle_class do
  let(:hash_circle) do
    circle_class.new {:center => [1,1], :radius => 5 }
  end
  
  let(:array_circle) do
    circle_class.new [ [1,1], 5 ]
  end
  
  describe '#to_a' do
    describe 'hash :lower_left, :upper_right' do
      it 'should convert to array of points' do
        hash_circle.to_a.should == [ [1,1], 5]
      end
    end

    describe 'array of 2 sub-arrays' do
      it 'should convert to array of points' do
        array_circle.to_a.should == [ [1,1], 5 ] # not sure this is correct?
      end
    end
  end

  describe '#to_query' do
    describe ':within :center' do
      op_a, op_b = :within, :center
      hash_circle.to_query.should == {"$#{op_a}" => {"$#{op_b}" => hash_circle.to_a } }
    end
  end
end