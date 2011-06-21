require "mongoid/spec_helper"

describe Mongoid::Field do
  extend FieldHelper
  configure!

  before do
    GeoPoint.coord_mode = :lng_lat
  end

  context 'Using core_ext of mongoid_geo' do
    describe "String" do    
      describe '#to_lng_lat' do
        it "should split a String into parts and convert to floats and maintain order" do
          arg = "23.5, -47".to_lng_lat
          puts "arg: #{arg}"
          address.location = arg
          address.location.should == [23.5, -47]
        end
      end

      describe '#to_lat_lng' do
        it "should split a String into parts and convert to floats and reverse order" do
          arg = "23.5, -47".to_lat_lng
          puts "arg: #{arg}"
          address.location = arg
          address.location.should == [-47, 23.5]
        end
      end
    end
  end

  describe "String array" do
    it "should convert Strings into floats" do
      address.location = ["23.5", "-48"].to_lng_lat
      address.location.should == [23.5, -48]
    end
  end


  describe "DMS format - using GeoCalc gem" do
    before do
      require 'geo_calc'
    end

    describe "String" do    
      it "should split a String into parts and convert to floats" do
        address.location = ["58 38 38N", "003 04 12W"].to_lng_lat
        address.location_lat.should > 58
        address.location_lng.should < 4
      end

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

    describe "String array" do
      it "should convert Strings into floats" do
        address.location = "58 38 38N, 003 04 12W".to_lng_lat
        address.location_lat.should > 58
        address.location_lng.should < 4
      end

      it "should convert Strings into floats" do
        address.location = "003 04 12W, 58 38 38N".to_lng_lat
        address.location_lat.should > 58
        address.location_lng.should < 4
      end
    end
  end
end