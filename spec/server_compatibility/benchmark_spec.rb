require "mongoid/geo_spec_helper"
require 'benchmark'

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

def delta
  (rand(10000) / 10000.0) - 0.5
end

describe 'Mongoid spherical geo_near distance calculations' do
  context "Spherical mode distance" do
    before do
      Mongoid::Geo.spherical = true
      
      @center  = Address.create(:location => {:lat => 31.5, :lng => -121.5}, :city => 'center')        
      5000.times do
        Address.create(:location => {:lat => 31 + delta, :lng => -121 + delta})
      end      
    end

    
    context 'Mongo DB 1.8' do
      it "calculate distance using Mongo 1.8 native distance calculation" do    
        puts Benchmark.measure { Address.geo_near @center.location, :location, :unit => :km, :mode => :sphere }
      end      
    end
  end
end
