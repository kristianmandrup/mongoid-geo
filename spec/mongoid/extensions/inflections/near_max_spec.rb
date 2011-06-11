require "mongoid/spec_helper"

describe Mongoid::Extensions::Symbol::Inflections do
  include InflectionsHelper
  
  describe "#nearMax" do
  
    let(:criteria) do
      base.where(:location.nearMax => [{:latitude => 72, :longitude => -44 }, 5])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
    end
  end  
  
  # this could be used to optimize calculation speed
  describe "#nearMax sphere and flat" do
  
    let(:criteria) do
      base.where(:location.nearMax(:flat, :sphere) => [{:lat => 72, :lng => -44 }, 5])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$near" => [ 72, -44 ], "$maxDistanceSphere" => 5 } }
    end
  end  

  # this could be used to optimize calculation speed
  describe "#nearMax hash values" do

    let(:point) do
      b = (Struct.new :lat, :lng).new
      b.lat = 72
      b.lng = -44
      b
    end
  
    let(:criteria) do
      base.where(:location.nearMax => {:point => point, :distance =>  5})
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
    end
  end  

  # this could be used to optimize calculation speed
  describe "#nearMax hash values" do
    let(:point_distance) do
      b = (Struct.new :point, :distance).new
      b.point = [72, -44]
      b.distance = 5
      b
    end
  
    let(:criteria) do
      base.where(:location.nearMax => point_distance)
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
    end
  end  

  describe "#nearMax sphere" do
  
    let(:criteria) do
      base.where(:location.nearMax(:sphere) => [[ 72, -44 ], 5])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$nearSphere" => [ 72, -44 ], "$maxDistanceSphere" => 5 } }
    end
  end  
end