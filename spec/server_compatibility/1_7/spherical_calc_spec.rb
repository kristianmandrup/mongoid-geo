require "mongoid/geo_spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

describe 'Mongoid Spherical geonear distance calculations : Mongo DB 1.8' do
  context "Normal mode distance" do    
    before do
      set_server_version(1.8)
    end

    after do
      clean_database!
    end

    before :each do
      @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
      @icc = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
    end
    
    it "calculate distance and sort them in descending distance order" do
      # d1 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms}) # 1.8078417965905265
      # d2 = Geokit::LatLng.distance_between(@center.location,@icc.location,{:units=> :kms,:formula => :flat}) # 1.5037404243943175

      Mongoid::Geo::Config.server_version.should == 1.8
      Mongoid::Geo.spherical.should be_false
      
      # results = Address.geoNear @center.location, :location, :distanceMultiplier => 111.17
      results = Address.geoNear @center.location, :location, :unit => :km, :dist_order => :desc

      distances = results.map(&:distance)  
      puts "distances: #{distances}"
      # # 1.8062052078680642
      hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371
      # distances.first.should be_within(0.5).of(hd)
    end      
  end # normal mode

  context "Spherical mode distance" do    
    before do
      Mongoid::Geo::Config.server_version = 1.8
    end

    before :each do
      @center = Address.create(:location => {:lat => 31.2010839, :lng => -121.583509}, :city => 'center')
      @icc    = Address.create(:location => {:lat => 31.2026708, :lng => -121.6024088}, :city => 'icc')
    end
  
    it "calculates distance" do
      Mongoid::Geo.mongo_db_version.should == 1.8
      Mongoid::Geo.spherical.should be_true
      
      results = Address.geoNear @center.location, :location, :unit => :km, :spherical => true
      distances = results.map(&:distance)
      puts "distances: #{distances}"  
      hd =  Mongoid::Geo::Haversine.distance(@center.lat, @center.lng, @icc.lat, @icc.lng) * 6371

      # c is  1.8061253521165859
      # hd is 1.8062052078680642
      distances.last.should be_within(0.5).of(hd)
    end      
  end 
end
