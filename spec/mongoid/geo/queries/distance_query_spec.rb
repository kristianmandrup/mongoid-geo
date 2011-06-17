require "mongoid/geo/spec_helper"

def distance_class
  Mongoid::Geo::DistanceQuery
end

describe distance_class do
  let(:center) { [1,1] }

  let(:hash_distance) do
    distance_class.new :point => center, :distance => 5
  end
  
  let(:array_distance) do
    distance_class.new [ center, 5 ]
  end
  
  describe '#to_a' do
    describe 'hash :point, :distance' do
      it 'should convert to array of points' do
        hash_distance.to_a.should == [ center, 5]
      end
    end

    describe 'array of 2 sub-arrays' do
      it 'should convert to array of points' do
        array_distance.to_a.should == [ center, 5 ] # not sure this is correct?
      end
    end
  end

  describe '#to_query' do
    describe ':within :center' do
      it 'should return mongo query hash' do
        op_a, op_b = :point, :distance
        expected_res = {"$#{op_a}" => hash_distance.to_a.first, "$#{op_b}" => hash_distance.to_a.last }      
        hash_distance.to_query(op_a, op_b).should == expected_res
      end
    end
  end
end

