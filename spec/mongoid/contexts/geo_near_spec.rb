require "mongoid/spec_helper"

describe Mongoid::Contexts::Mongo do

  before(:each) do
    Address.create(:location => [45, 11], :city => 'Munich')
    Address.create(:location => [46, 12], :city => 'Berlin')
  end

  describe "geo_near" do
    it "should work with specifying specific center and different location attribute on collction" do
      location = [-47,23.5]
      Address.geo_near(location).first.location[0].should == 45
    end
    
    it "should assume same attribute searched on both center instance and collection" do
      location = [-47,23.5]
      Address.geo_near(location).first.location[0].should == 45
    end

    describe 'option :num' do
      it "should limit number of results to 1" do
        location = [-47,23.5]
        Address.geo_near(location, :num => 1).size.should == 1
      end
    end
    
    describe 'option :maxDistance' do
      it "should limit on maximum distance" do
        location = [45.1, 11.1]
        # db.runCommand({ geo_near : "points", near :[45.1, 11.1]}).results;
        # dis: is 0.14141869255648362  and  1.2727947855285668 
        Address.geo_near(location, :max_distance => 0.2).size.should == 1
      end
    end
    
    describe 'option :distanceMultiplier' do
      it "should multiply returned distance with multiplier" do
        location = [45.1, 11.1]
        Address.geo_near(location, :distance_multiplier => 4).map(&:distance).first.to_kilometers.should > 0
      end
    end
    
    describe 'option :query' do
      it "should filter using extra query option" do
        location = [45.1, 11.1]
        # two record in the collection, only one's city is Munich
        Address.geo_near(location, :query => {:city => 'Munich'}).size.should == 1
      end
    end

    describe 'criteria chaining' do
      it "should filter by where" do
        location = [45.1, 11.1]
        # two record in the collection, only one's city is Munich
        a = Address.where(:city => 'Munich')
        p a.selector
        a.geo_near(location).size.should == 1
      end

      it 'should skip 1' do
        location = [-47,23.5]
        Address.skip(1).geo_near(location).size.should == 1
      end

      it 'should limit 1' do
        location = [-47,23.5]
        Address.limit(1).geo_near(location).size.should == 1
      end

    end

  end
end
