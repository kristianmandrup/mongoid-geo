require "mongoid/spec_helper"

describe Mongoid::Field do
  extend FieldHelper
  configure!

  # before do
  #   Mongoid::Geo.config.enable_extension! :geo_array
  # end

  before do
    GeoPoint.coord_mode = :lng_lat
  end
  
  describe "Special geo Array setter" do
    pending 'Will work in next release of geo_calc or geo_point gems'
    
    it "should split a String into parts and convert to floats" do
      puts "23.5, -47".to_lng_lat

      puts GeoPoint.coord_mode
      puts "23.5, -47".geo_point
      
      address.location = "23.5, -47".geo_point #.to_lng_lat
      address.location.should == [23.5, -47]
    end
    
    it "should convert Strings into floats" do
      address.location = ["23.5", "-48"].to_lng_lat
      address.location.should == [23.5, -48]
    end
  end
end