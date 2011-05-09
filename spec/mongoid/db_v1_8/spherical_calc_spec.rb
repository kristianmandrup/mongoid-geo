require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

describe 'Mongoid Spherical geonear distance calculations' do
  context "Normal mode distance" do    
    before do
      Mongoid::Geo.spherical = false
    end

    after do
      Mongoid.database.collections.each do |coll|
        coll.remove
      end
    end

    context 'Mongo DB < 1.7' do
      before do
        Mongoid::Geo.mongo_db_version = 1.6
      end

      before :each do
        @center = Address.new(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
        @center.save!
        @icc = Address.new(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
        @icc.save!
      end
    
      it "calculate distance" do
        # d1 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms}) # 1.8078417965905265
        # d2 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms,:formula => :flat}) # 1.5037404243943175

        Mongoid::Geo.mongo_db_version.should == 1.6
        Mongoid::Geo.spherical.should be_false
        
        # results = Address.geoNear @center.location, :location, :distanceMultiplier => 111.17
        results = Address.geoNear @center.location, :location, :unit => :km
        
        distances = results.asc(:distance).map(&:distance)  
        puts "distances: #{distances}"
        # # 1.8062052078680642
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
        distances.last.should be_within(0.005).of(hd)
      end      
    end

    context 'Mongo DB 1.8' do
      before do
        Mongoid::Geo.mongo_db_version = 1.8
      end    
      
      after do
        Mongoid::Geo.mongo_db_version = 1.6
      end      

      before :each do
        @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
        @icc = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
      end
    
      it "calculate distance and sort them in descending distance order" do
        # d1 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms}) # 1.8078417965905265
        # d2 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms,:formula => :flat}) # 1.5037404243943175

        Mongoid::Geo.mongo_db_version.should == 1.8
        Mongoid::Geo.spherical.should be_false
        
        # results = Address.geoNear @center.location, :location, :distanceMultiplier => 111.17
        results = Address.geoNear @center.location, :location, :unit => :km, :dist_order => :desc

        distances = results.map(&:distance)  
        puts "distances: #{distances}"
        # # 1.8062052078680642
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
        # distances.first.should be_within(0.5).of(hd)
      end      
    end
  end

  context "Spherical mode distance" do
    before do
      Mongoid::Geo.spherical = true
    end

    after do
      Mongoid::Geo.spherical = false
    end      

    context 'Mongo DB < 1.7' do
      before do
        Mongoid::Geo.mongo_db_version = 1.6
      end

      before :each do
        @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
        @icc    = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
      end
    
      it "calculate distance" do
        # d1 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms}) # 1.8078417965905265
        # d2 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms,:formula => :flat}) # 1.5037404243943175

        Mongoid::Geo.mongo_db_version.should == 1.6
        Mongoid::Geo.spherical.should be_true
        
        results = Address.geoNear @center.location, :location, :unit => :km
        
        distances = results.desc(:distance).map(&:distance)  
        puts "distances: #{distances}"
        # # 1.8062052078680642
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
        distances.first.should be_within(0.5).of(hd)
      end      
    end
    
    context 'Mongo DB 1.8' do
      before do
        Mongoid::Geo.mongo_db_version = 1.8
        Mongoid::Geo.spherical = true
      end

      after do
        Mongoid::Geo.mongo_db_version = 1.6
        Mongoid::Geo.spherical = false
      end

      before :each do
        @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
        @icc    = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
      end
    
      it "calculates distance" do
        Mongoid::Geo.mongo_db_version.should == 1.8
        Mongoid::Geo.spherical.should be_true
        
        results = Address.geoNear @center.location, :location, :unit => :km, :mode => :sphere
        distances = results.map(&:distance)
        puts "distances: #{distances}"  
        hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371

        # c is  1.8061253521165859
        # hd is 1.8062052078680642
        distances.last.should be_within(0.5).of(hd)
      end      
    end
  end
end