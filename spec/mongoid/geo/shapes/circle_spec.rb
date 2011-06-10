require "mongoid/geo_spec_helper"

def circle_class
  Mongoid::Geo::Shapes::Circle
end

describe circle_class do
  let(:circle) do
    circle_class.new {:center => [1,1], :radius => 5 }
  end
  
  describe '#to_a' do
    pending 'TODO'
  end

  describe '#to_query' do
    pending 'TODO'
  end
end