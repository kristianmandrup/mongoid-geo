require "mongoid/geo_spec_helper"

def box_class
  Mongoid::Geo::Shapes::Box
end

describe box_class do
  let(:box) do
    box_class.new {:lower_left => [1,1], :upper_right => [2,2] }
  end
  
  describe '#to_a' do
    pending 'TODO'
  end

  describe '#to_query' do
    pending 'TODO'
  end
end