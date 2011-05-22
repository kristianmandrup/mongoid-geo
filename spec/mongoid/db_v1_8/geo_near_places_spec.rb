require "mongoid/spec_helper"

Mongoid::Geo.mongo_db_version = 1.8

# Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

[Address].create_geo_indexes!

class Place
 include Mongoid::Document
 extend Mongoid::Geo::Near
 field :loc, type: Array, :geo => true
 geo_index :loc
end

Place.collection.create_index([['loc', Mongo::GEO2D]], :min => -180, :max => 180)

describe Mongoid::Geo::Near do
  describe 'place' do
    before(:each) do
      Place.create(:loc => [45, 11])
      Place.create(:loc => [46, 12])
    end

    it 'should return places near' do
      @places = Place.geoNear([44, 11.5], :loc)
      pp @places.to_a
    end
  end
end