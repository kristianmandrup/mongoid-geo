require "mongoid/spec_helper"

describe Mongoid::Fields do

  let(:address) do
    Address.new
  end

  describe "Special geo Array setter" do
    it "should split a String into parts and convert to floats" do
      address.locations = "23.5, -47"
      address.locations.should == [23.5, -47]
    end

    it "should convert Strings into floats" do
      address.locations = "23.5", "-48"
      address.locations.should == [23.5, -48]
    end

    it "should default to normal behavior" do
      address.locations = 23.5, -49
      address.locations.should == [23.5, -49]

      address.locations = [23.5, -50]
      address.locations.should == [23.5, -50]
    end
  end
end