require "mongoid/spec_helper"

describe Mongoid::Field do
  extend FieldHelper
  configure!
  
  describe "Special geo Array setter" do
    pending 'Will work in next release of geo_calc or geo_point gems'
    
    it "should split a String into parts and convert to floats" do
      arg = "23.5, -47".to_lng_lat
      puts "arg: #{arg}"       
      address.location = arg
      address.location.should == [23.5, -47]
    end
    
    it "should convert Strings into floats" do
      address.location = ["23.5", "-48"].to_lng_lat
      address.location.should == [23.5, -48]
    end
  end
end