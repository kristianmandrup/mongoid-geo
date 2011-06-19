require "mongoid/spec_helper"

describe 'Using Geo Point' do
  before do
    Mongoid::Geo.enable_extension! :geo_point # this used to work!
  end

  let(:address) do
    Address.new        
  end

  let(:p1) do
    GeoPoint.new "58 38 38N", "003 04 12W"
  end

  it 'should work' do
    p1.should be_a(GeoPoint)    
    address.location = p1.to_lng_lat
    address.location_lat.should be_within(0.5).of(58.38)
    address.location_lng.should be_within(0.5).of(-3)
  end
end