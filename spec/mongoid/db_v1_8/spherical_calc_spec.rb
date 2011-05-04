require "mongoid/spec_helper"

Mongoid::Geo.mongo_db_version = 1.8
Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

describe 'Mongoid Spherical mode' do

  describe "Spherical mode distance" do    
    context 'Mongo DB 1.8' do
      before do
        Mongoid::Geo.mongo_db_version = 1.8
        Mongoid::Geo.spherical = true
      end

      after do
        Mongoid::Geo.mongo_db_version = 1.5
        Mongoid::Geo.spherical = false
      end

      before :each do
        @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
        @icc = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
      end
    
      it " cal distance" do

        Mongoid::Geo.mongo_db_version.should == 1.8
        Mongoid::Geo.spherical.should be_true
        
        results = Address.geoNear @center.location, :location, :distanceMultiplier => 6371,:mode => :sphere

        c = results.map(&:distance)  
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
        # c is  1.8061253521165859
        # hd is 1.8062052078680642
        c.last.should be_within(0.5).of(hd)
      end      
    end
  end
end