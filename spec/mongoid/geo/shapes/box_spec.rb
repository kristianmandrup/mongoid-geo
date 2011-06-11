require "mongoid/spec_helper"

def box_class
  Mongoid::Geo::Shapes::Box
end

describe box_class do
  let(:hash_box) do
    box_class.new {:lower_left => [1,1], :upper_right => [2,2] }
  end

  let(:array_box) do
    box_class.new [ [1,1], [2,2] ]
  end
  
  describe '#to_a' do
    describe 'hash :lower_left, :upper_right' do
      it 'should convert to array of points' do
        hash_box.to_a.should == [ [1,1], [2,2] ]
      end
    end

    describe 'array of 2 sub-arrays' do
      it 'should convert to array of points' do
        array_box.to_a.should == [ [1,1], [2,2] ] # not sure this is correct?
      end
    end
  end

  describe '#to_query' do
    describe ':within :box' do
      op_a, op_b = :within, :box
      hash_box.to_query.should == {"$#{op_a}" => {"$#{op_b}" => hash_box.to_a } }
    end
  end
end