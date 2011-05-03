require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

describe 'Mongoid Spherical mode' do

  describe "Spherical mode distance" do    
    context 'Mongo DB < 1.7' do
      before do
        Mongoid::Geo.mongo_db_version = 1.6
      end

      before :each do
        @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
        @icc = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
      end
    
      it " cal distance" do
        # d1 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms}) # 1.8078417965905265
        # d2 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms,:formula => :flat}) # 1.5037404243943175

        Mongoid::Geo.mongo_db_version.should == 1.6
        Mongoid::Geo.spherical.should be_false
        
        # results = Address.geoNear @center.location, :location, :distanceMultiplier => 100
        results = Address.geoNear @center.location, :location, :unit => :km

        c = results.map(&:distance)  
        # puts "c: #{c}"
        # # 1.8062052078680642
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
        c.last.should be_within(0.005).of(hd)
      end      
    end

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
        # @center = Address.create(:location => {:lng => 31.2010839, :lat => -121.583509}, :city => 'center')
        @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')

        # @icc = Address.create(:location => {:lng => 31.2026708, :lat => -121.6024088}, :city => 'icc')
        @icc = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
      end
    
      it " cal distance" do
        # d1 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms}) # 1.8078417965905265
        # d2 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms,:formula => :flat}) # 1.5037404243943175

        Mongoid::Geo.mongo_db_version.should == 1.8
        Mongoid::Geo.spherical.should be_true
        
        results = Address.geoNear @center.location, :location, :distanceMultiplier => 100 # ???
        # results = Address.geoNear @center.location, :location, :unit => :km
        # puts "near results: #{results}"

        c = results.map(&:distance)  
        # puts "c: #{c}"
        # # 1.8062052078680642
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
        c[1].should be_within(0.5).of(hd) # ??? TOO BIG VARIANCE!?
      end      
    end
  end
end