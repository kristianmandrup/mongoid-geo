require "mongoid/spec_helper"
require 'benchmark'

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

def delta
  (rand(10000) / 10000.0) - 0.5
end

describe 'Mongoid Spherical geonear distance calculations' do
  context "Spherical mode distance" do
    before do
      Mongoid::Geo.spherical = true
      
      @center  = Address.create(:location => {:lat => 31.5, :lng => -121.5}, :city => 'center')        
      5000.times do
        Address.create(:location => {:lat => 31 + delta, :lng => -121 + delta})
      end      
    end

    context 'Mongo DB < 1.7' do
      before do
        Mongoid::Geo.mongo_db_version = 1.6
      end
    
      it "calculates distance using ruby Haversine code" do
        Mongoid::Geo.mongo_db_version.should == 1.6
        Mongoid::Geo.spherical.should be_true

        puts Benchmark.measure { Address.geoNear @center.location, :location, :unit => :km }
      end      
    end
    
    context 'Mongo DB 1.8' do
      before do
        Mongoid::Geo.mongo_db_version = 1.8
        Mongoid::Geo.spherical = true
      end

      it "calculate distance using Mongo 1.8 native distance calculation" do    
        Mongoid::Geo.mongo_db_version.should == 1.8
        Mongoid::Geo.spherical.should be_true
        
        puts Benchmark.measure { Address.geoNear @center.location, :location, :unit => :km, :mode => :sphere }
      end      
    end
  end
end