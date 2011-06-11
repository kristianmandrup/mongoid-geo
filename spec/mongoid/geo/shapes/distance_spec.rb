require "mongoid/spec_helper"

def distance_class
  Mongoid::Geo::Shapes::Distance
end

describe distance_class do
  let(:hash_distance) do
    distance_class.new {:point => [1,1], :distance => 5 }
  end
  
  let(:array_distance) do
    distance_class.new [ [1,1], 5 ]
  end
  
  describe '#to_a' do
    describe 'hash :point, :distance' do
      it 'should convert to array of points' do
        hash_distance.to_a.should == [ [1,1], 5]
      end
    end

    describe 'array of 2 sub-arrays' do
      it 'should convert to array of points' do
        array_distance.to_a.should == [ [1,1], 5 ] # not sure this is correct?
      end
    end
  end

  describe '#to_query' do
    describe ':within :center' do
      op_a, op_b = :point, :distance
      expected_res = {"$#{op_a}" => hash_distance.first, "$#{op_b}" => hash_distance.last }
      
      hash_distance.to_query.should == expected_res
    end
  end
end

