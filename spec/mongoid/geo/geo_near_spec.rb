require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

describe Mongoid::Geo::Near do

  let(:address) do
    Address.new        
  end  
  
  before(:each) do
    Address.create(:location => [45, 11], :city => 'Munich')
    Address.create(:location => [46, 12], :city => 'Berlin')
  end

  describe "geoNear" do
    it "should work with specifying specific center and different location attribute on collction" do
      address.location = "23.5, -47"
      Address.geoNear(address.location, :location).first.location[0].should == 45
    end
    
    it "should assume same attribute searched on both center instance and collection" do
      address.location = "23.5, -47"
      Address.geoNear(address, :location).first.location[0].should == 45
    end

    describe 'option :num' do
      it "should limit number of results to 1" do
        address.location = "23.5, -47"
        Address.geoNear(address, :location, :num => 1).size.should == 1
      end
    end
    
    describe 'option :maxDistance' do
      it "should limit on maximum distance" do
        address.location = "45.1, 11.1"
        # db.runCommand({ geoNear : "points", near :[45.1, 11.1]}).results;
        # dis: is 0.14141869255648362  and  1.2727947855285668 
        Address.geoNear(address, :location, :maxDistance => 0.2).size.should == 1
      end
    end
    
    describe 'option :distanceMultiplier' do
      it "should multiply returned distance with multiplier" do
        address.location = "45.1, 11.1"
        Address.geoNear(address, :location, :distanceMultiplier => 4).map(&:distance).first.should > 0
      end
    end
    
    describe 'option :query' do
      it "should filter using extra query option" do
        address.location = "45.1, 11.1"
        # two record in the collection, only one's city is Munich
        Address.geoNear(address, :location, :query => {:city => 'Munich'}).size.should == 1
      end
    end
  end
end