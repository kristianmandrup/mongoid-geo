require "mongoid/spec_helper"

describe Mongoid::Fields do

  let(:address) do
    Address.new        
  end
  
  let(:point) do
    b = (Struct.new :lat, :lng).new
    b.lat = 72
    b.lng = -44
    b
  end  

  let(:location) do
    a = (Struct.new :location).new
    a.location = point
    a
  end  

  let(:position) do
    a = (Struct.new :position).new
    a.position = point
    a
  end  


  let(:other_point) do
    b = (Struct.new :latitude, :longitude).new
    b.latitude = 72
    b.longitude = -44
    b
  end  


  describe "Special geo Array setter" do
    it "should split a String into parts and convert to floats" do
      address.location = "23.5, -47"
      address.location.should == [23.5, -47]
    end
    
    it "should convert Strings into floats" do
      address.location = "23.5", "-48"
      address.location.should == [23.5, -48]
    end
    
    it "should work with point Hash, keys :lat, :lng" do
      address.location = {:lat => 23.5, :lng => -49}
      address.location.should == [23.5, -49]
    end
    
    it "should work with point Hash, keys :latitude, :longitude" do
      address.location = {:latitude => 23.5, :longitude => -49}
      address.location.should == [23.5, -49]
    end
    
    
    it "should work with point hashes using the first point only" do
      address.location = [{:lat => 23.5, :lng => -49}, {:lat => 72, :lng => -49}]
      address.location.should == [23.5, -49]
    end
    
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
    
    it "should drop nils" do
      address.location = [nil, point, {:lat => 72, :lng => -49}]
      address.location.should == [72, -44]
    end
    
    it "should default to normal behavior" do
      address.location = 23.5, -49
      address.location.should == [23.5, -49]
    
      address.location = [23.5, -50]
      address.location.should == [23.5, -50]
    end
    
    it "should handle nil values" do
      address.location = nil
      address.location.should be_nil
      address.lat.should      be_nil
      address.lng.should      be_nil
    end 
  end
end