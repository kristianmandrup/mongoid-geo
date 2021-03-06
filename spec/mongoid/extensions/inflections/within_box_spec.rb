require "mongoid/spec_helper"

describe Mongoid::Extensions::Symbol::Inflections do
  extend InflectionsHelper
  configure!

  describe "#within_box" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    
    let(:criteria) do
      base.where(:location.within_box => [point_a, point_b])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$box" => [point_a, point_b] } } }
    end
  end  

  describe "#within_box, one hash point" do  
    let(:point_a) do 
      {:lat => 72, :lng => -44 }
    end
    let(:point_b) { [ 71, -45 ] }      
    
    let(:criteria) do
      base.where(:location.within_box => [point_a, point_b])
    end
  
    it "adds the $within and $box modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$box" => [[72, -44], [ 71, -45 ]] } } }
    end
  end  


  describe "#within_box hash box" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    let(:box) do
      {:lower_left => point_a, :upper_right => point_b}
    end
    
    let(:criteria) do
      base.where(:location.within_box => box)
    end
  
    it "adds the $within and $box modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$box" => [point_a, point_b] } } }
    end
  end  

  describe "#within_box Struct box" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    let(:box) do
      b = (Struct.new :lower_left, :upper_right).new
      b.lower_left = point_a
      b.upper_right = point_b
      b
    end
    
    let(:criteria) do
      base.where(:location.within_box => box)
    end
  
    it "adds the $within and $box modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$box" => [point_a, point_b] } } }
    end
  end  

  describe "#within_box Sphere" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    
    let(:criteria) do
      base.where(:location.within_box(:sphere) => [point_a, point_b])
    end
  
    it "adds the $within and $boxSphere modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$boxSphere" => [point_a, point_b] } } }
    end
  end  
end