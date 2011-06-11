require "mongoid/geo/spec_helper"

def config_class
  Mongoid::Geo::Config
end

def config &block
  Mongoid::Geo.config &block
end

module AnotherDistanceCalculator
  def self.distance(a,b,c,d)
  end
end

module InvalidDistanceCalculator
  def self.dist
  end
end


describe Mongoid::Geo::Config do
  describe '#server_version' do
    it 'should set version to 1.6 using block' do
      config do |c|
        c.server_version = 1.6
      end    
      config_class.server_version.should == 1.6
    end
  
    it 'should set version to 1.8' do
      config.server_version = 1.8
      config_class.server_version.should == 1.8
    end
  end

  describe '#coord_mode' do
    it 'should set mode to :lng_lat using block' do
      config do |c|
        c.coord_mode = :lng_lat
      end    
      config_class.coord_mode.should == :lng_lat
    end
  
    it 'should set mode to :lat_lng' do
      config do |c|
        c.coord_mode = :lat_lng
      end    
      config_class.coord_mode.should == :lat_lng
    end
  end
  
  describe '#distance_calculator' do
    it 'distance_calculator should be set to Haversine by default' do
      config_class.distance_calculator.should == Haversine
    end

    it 'distance_calculator should be set to an invalid Distance Calculator module' do
      lambda { config.distance_calculator = FakeDistanceCalculator }.should raise_error
      config_class.distance_calculator.should_not == InvalidDistanceCalculator
    end
  
    it 'should set distance_calculator to a valid AnotherDistanceCalculator using block' do
      config do |c|
        c.distance_calculator = AnotherDistanceCalculator
      end    
      config_class.distance_calculator.should == AnotherDistanceCalculator
    end        
  end
  
  describe '#distance_formula' do
    it 'should set formular to :sphere using block' do
      config do |c|
        c.distance_formula = :sphere
      end    
      config_class.distance_formula.should == :sphere
    end
  
    it 'should set formula to :flat' do
      config do |c|
        c.distance_formula = :flat
      end    
      config_class.distance_formula.should == :flat
    end
  end
  
  describe '#units' do
    it 'should set units to :miles using block' do
      config do |c|
        c.units = :miles
      end    
      config_class.units.should == :miles
    end
  
    it 'should set units to :kms' do
      config do |c|
        c.units = :kms
      end    
      config_class.units.should == :kms
    end
  end
end
