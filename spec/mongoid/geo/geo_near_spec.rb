require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

describe Mongoid::Geo::Near do

  let(:address) do
    Address.new        
  end  

  before do
    Address.create(:location => [45, 11])
    Address.create(:location => [46, 12])
  end

  describe "geoNear" do
    it "should work with specifying specific center and different location attribute on collction" do
      address.location = "23.5, -47"
      puts Address.geoNear(address.location, :location)
    end

    it "should assume same attribute searched on both center instance and collection" do
      address.location = "23.5, -47"
      puts Address.geoNear(address, :location)
    end
  end
end