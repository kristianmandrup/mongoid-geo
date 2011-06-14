require "mongoid/spec_helper"

describe Mongoid::Field do
  extend FieldHelper
  configure!

  describe "Nil handling" do        
    it "should handle nil values" do
      address.location = nil
      address.location.should be_nil
      address.lat.should      be_nil
      address.lng.should      be_nil
    end
    
    it "should allow lat then lon assignment when nil" do
      address.location = nil
      address.lat = 41
      address.lng = -71
      address.location.should == [41, -71]
    end
    
    it "should allow lon then lat assignment when nil" do
      address.location = nil
      address.lng = -71
      address.lat = 41
      address.location.should == [41, -71]
    end
  end  
end
