require "mongoid/spec_helper"

class GeoPoint
  mattr_accessor :coord_mode
end

describe 'geo_calc extension' do
  extend FieldHelper
  configure!

  before do
    Mongoid::Geo.enable_extension! :geo_calc
    GeoPoint.coord_mode = :lng_lat
  end

  describe 'String' do
    describe '#to_lng_lat' do
      it "should maintain order" do
        address.location = ["23.5", "-48"].to_lng_lat
        address.location.should == [23.5, -48]
      end
    end

    describe '#to_lat_lng' do
      it "should reverse order" do
        address.location = ["23.5", "-48"].to_lat_lng
        address.location.should == [-48, 23.5]
      end
    end
  end

  describe "DMS format" do
    describe "Array with 2 Strings" do    
      it "should split DMS String into parts and convert to floats" do
        address.location = ["58 38 38N", "003 04 12W"].to_lng_lat
        address.location_lat.should > 58
        address.location_lng.should < 4
      end
    end

    describe "DMS String" do
      it "should convert (lat, lng) DMS String into (lng, lat) floats" do
        address.location = "58 38 38N, 003 04 12W".to_lng_lat
        address.location_lat.should > 58
        address.location_lng.should < 4
      end

      it "should convert (lng, lat) DMS Strings into (lng, lat) floats" do
        address.location = "003 04 12W, 58 38 38N".to_lng_lat
        address.location_lat.should > 58
        address.location_lng.should < 4
      end
    end
  end
end