require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)

class Place
 include Mongoid::Document
 field :loc, type: Array, :geo => true
end

describe Mongoid::Contexts::Mongo do
  describe 'place' do
    before(:each) do
      Place.create(:loc => [45, 11])
      Place.create(:loc => [46, 12])
    end

    it 'should return places near' do
      @places = Place.geo_near([44, 11.5], :loc)
      pp @places.to_a
    end
  end
end
