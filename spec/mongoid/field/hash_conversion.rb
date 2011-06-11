require "mongoid/spec_helper"

describe Mongoid::Field do
  extend FieldHelper
  configure!

  describe "Hash conversions" do
    pending 'TODO' # :geo field should use .geo_point internally for parsing!

    # it "should work with point Hash, keys :lat, :lng" do
    #   address.location = {:lat => 23.5, :lng => -49}
    #   address.location.should == [23.5, -49]
    # end
    # 
    # it "should work with point Hash, keys :latitude, :longitude" do
    #   address.location = {:latitude => 23.5, :longitude => -49}
    #   address.location.should == [23.5, -49]
    # end
    # 
    # it "should work with point Hash keys 0 and 1" do
    #   address.location = {"0" => 41, "1" => -71}
    #   address.location.should == [41, -71]
    # end
    # 
    # 
    # it "should work with point hashes using the first point only" do
    #   address.location = [{:lat => 23.5, :lng => -49}, {:lat => 72, :lng => -49}]
    #   address.location.should == [23.5, -49]
    # end
  end
end