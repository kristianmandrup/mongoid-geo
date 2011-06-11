require "mongoid/spec_helper"
require "geo_calc"
# require "geo_calc/macros"

describe Mongoid::Fields do
  describe 'Assign location using a GeoPoint' do
    let(:address) do
      Address.new        
    end

    let(:hash_geo_point) do
      {:lat => 72, :lng => -44}.geo_point
    end  

    # Note: GeoPoint macro uses [lat, lng] format  
    # You can also do GeoPoint.new(lat, lng) and such (see 'geo_calc' gem on github)
    let(:array_geo_point) do
      [72, -44].geo_point
    end  

    describe "GeoPoint from Hash" do
      it "should return location as lng, lat" do
        address.location = hash_geo_point
        address.location.should == [-44, 72]
      end
    end

    describe "GeoPoint from Array" do
      it "should return location as lng, lat" do
        address.location = array_geo_point
        address.location.should == [-44, 72]
      end
    end
  end
end