require "mongoid/geo_spec_helper"
require "mongoid/helper/field"

describe Mongoid::Field do
  include FieldHelper

  describe "Point conversions" do
    it "should work with point object has #lat and #lng methods" do
      address.location = point
      address.location.should == [72, -44]
    end

    it 'should work with point object that has location attribute' do
      address.location = location
      address.location.should == [72, -44]
    end

    it 'should work with point object that has position attribute add should add #lat and #lng methods' do
      address.location = position
      address.location.should == [72, -44]
      address.lat.should == 72
      address.lng.should == -44
    end

    it 'should work with point object that has position attribute and should add #latitude and #longitude methods' do
      address.pos = position
      address.pos.should == [72, -44]
      address.latitude.should == 72
      address.latitude = 45
      address.latitude.should == 45
      address.longitude.should == -44
    end

    it 'should work with point object that has #latitude and #longitude methods' do
      address.location = other_point
      address.location.should == [72, -44]
    end

    it "should work with point objects using the first point only" do
      address.location = [point, {:lat => 72, :lng => -49}]
      address.location.should == [72, -44]
    end
  end
end