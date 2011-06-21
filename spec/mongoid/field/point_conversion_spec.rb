require "mongoid/spec_helper"

describe Mongoid::Fields do
  extend FieldHelper
  configure!

  describe "Point conversions" do
    it "should work with point object has #lat and #lng methods" do
      address.location = point.to_lng_lat
      address.location.should == [-44, 72]
    end

    it 'should work with point object that has location attribute' do
      address.location = location.to_lng_lat
      address.location.should == [-44, 72]
    end

    it 'should work with point object that has position attribute add should add #lat and #lng methods' do
      address.location = position.to_lng_lat
      address.location.should == [-44, 72]
    end

    it 'should work with point object that has position attribute and should add #latitude and #longitude methods' do
      address.pos = position.to_lng_lat
      address.pos.should == [-44, 72]
    end

    
    it 'should work with point object that has #latitude and #longitude methods' do
      address.location = other_point.to_lng_lat
      address.location.should == [-44, 72]
    end    
  end
end