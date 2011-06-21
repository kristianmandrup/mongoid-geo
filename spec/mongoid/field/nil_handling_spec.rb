require "mongoid/spec_helper"
require 'geo_calc'
mongoid_field = (defined?(Mongoid::Field)) ? Mongoid::Field : Mongoid::Fields

describe mongoid_field do
  extend FieldHelper
  configure!

  describe "Nil handling" do        
    it "should handle nil values" do
      address.location = nil
      address.location.should be_nil
      address.location_lat.should be_nil
      address.location_lng.should be_nil
    end
    
    it "should allow lat then lon assignment when nil" do
      address.location = nil
      address.location_lat = 41
      address.location_lng = -71
      address.location.should == [-71, 41]
    end
    
    it "should allow lon then lat assignment when nil" do
      address.location = nil
      address.location_lng = -71
      address.location_lat = 41
      address.location.should == [-71, 41]
    end
  end  
end
