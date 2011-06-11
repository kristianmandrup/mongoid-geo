require "mongoid/spec_helper"
require "mongoid/helper/field"

describe Mongoid::Field do
  include FieldHelper

  describe "Special geo Array setter" do
    it "should split a String into parts and convert to floats" do
      address.location = "23.5, -47"
      address.location.should == [23.5, -47]
    end
    
    it "should convert Strings into floats" do
      address.location = "23.5", "-48"
      address.location.should == [23.5, -48]
    end
  end
end