require "mongoid/geo_spec_helper"

def distance_class
  Mongoid::Geo::Shapes::Distance
end

describe distance_class do
  let(:distance) do
    distance_class.new {:point => [1,1], :distance => 5 }
  end
  
  describe '#to_a' do
    pending 'TODO'
  end

  describe '#to_query' do
    pending 'TODO'
  end
end