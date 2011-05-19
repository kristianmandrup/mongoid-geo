require "spec_helper"

describe Mongoid::Geo do
  let(:mongoid_geo){ Mongoid::Geo }

  context 'Without a configuration initializer' do

    it 'sets the mongo_db_version to default of 1.8' do
      mongoid_geo.mongo_db_version.should == 1.8
    end

    it 'sets the distance_formula to defaul of :spherical' do
      mongoid_geo.distance_formula.should == :spherical
    end

    it 'sets the default_units to default of :miles' do
      mongoid_geo.default_units.should == :miles
    end

  end

  context 'With a configuration initializer block' do

    before do
      mongoid_geo.setup do |config|
        config.mongo_db_version = 1.7
        config.distance_formula = :flat
        config.default_units = :km
      end
    end

    it 'sets the mongo_db_version' do
      mongoid_geo.mongo_db_version.should == 1.7
    end

    it 'sets the distance_formula' do
      mongoid_geo.distance_formula.should == :flat
    end

    it 'sets the default_units' do
      mongoid_geo.default_units.should == :km
    end

  end

  context 'Autoloads Mongoid::Geo modules' do

    it 'loads Mongoid::Geo::Point' do
      Mongoid::Geo::Point.should_not be_nil
    end

    it 'loads Mongoid::Geo::Unit' do
      Mongoid::Geo::Unit.should_not be_nil
    end

  end

end
