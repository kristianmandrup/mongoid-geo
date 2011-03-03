require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)


Address.create(:location => [45, 11], :city => 'Munich')
Address.create(:location => [46, 12], :city => 'Berlin')

describe Mongoid::Geo::Near do

  let(:address) do
    Address.new        
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

    describe '#to_models' do
      it "should return models" do
        address.location = "23.5, -47"
        models = Address.geoNear(address, :location, :num => 1).to_models
        models.first.lat.should == 45
      end
    end

    describe '#to_model' do
      it "should return model" do
        address.location = "23.5, -47"
        my_model = Address.geoNear(address, :location, :num => 1).first.to_model
        my_model.lat.should == 45
      end
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
        Address.geoNear(address, :location, :maxDistance => 0.2).size.should == 1
      end
    end
    
    describe 'option :distanceMultiplier' do
      it "should multiply returned distance with multiplier" do
        address.location = "45.1, 11.1"
        Address.geoNear(address, :location, :distanceMultiplier => 4).map(&:distance).first.should > 10
      end
    end
    
    describe 'option :query' do
      it "should filter using extra query option" do
        address.location = "45.1, 11.1"
        Address.geoNear(address, :location, :query => {:city => 'Munich'}).size.should == 1
      end
    end
  end
end