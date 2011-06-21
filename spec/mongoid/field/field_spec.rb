require "mongoid/spec_helper"

describe Mongoid::Fields do
  extend FieldHelper  
  configure!

  describe "Normal behavior" do       
    it "should default to normal behavior" do
      address.location = 23.5, -49
      address.location.should == [23.5, -49]
    
      address.location = [23.5, -50]
      address.location.should == [23.5, -50]
    end
  end
end
