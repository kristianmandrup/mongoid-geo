require "mongoid/spec_helper"

describe Mongoid::Field do
  extend FieldHelper
  configure!

  describe "Hash conversions" do
    it "should work with point Hash, keys :lat, :lng" do
      address.location = {:lat => 23.5, :lng => -49}.to_lng_lat
      address.location.should == [23.5, -49]
    end
    
    it "should work with point Hash, keys :latitude, :longitude" do
      address.location = {:latitude => 23.5, :longitude => -49}.to_lng_lat
      address.location.should == [23.5, -49]
    end    
  end
end