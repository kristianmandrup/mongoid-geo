require "mongoid/spec_helper"
mongoid_field = (defined?(Mongoid::Field)) ? Mongoid::Field : Mongoid::Fields


class GeoPoint
  mattr_accessor :coord_mode
end

describe mongoid_field do
  extend FieldHelper
  configure!

  before do
    GeoPoint.coord_mode = :lng_lat
  end

  context 'Using core_ext of mongoid_geo' do
    describe "String" do    
      describe '#to_lng_lat' do
        it "should split a String into parts and convert to floats and maintain order" do
          address.location = "23.5, -47".to_lng_lat
          address.location.should == [23.5, -47]
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
end

