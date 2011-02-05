require "mongoid/spec_helper"

describe Mongoid::Criterion::Inclusion do

  let(:base) do
    Mongoid::Criteria.new(Address)
  end
  
  describe "#nearSphere" do
    let(:criteria) do
      base.where(:locations.nearSphere => [ 72, -44 ])
    end

    it "returns a selector matching a ne clause" do
      criteria.selector.should ==
        { :locations => { "$nearSphere" => [ 72, -44 ] } }
    end
  end

  describe "#nearMax" do
  
    let(:criteria) do
      base.where(:locations.nearMax => [[ 72, -44 ], 5])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
    end
  end  

  describe "#nearMax sphere" do
  
    let(:criteria) do
      base.where(:locations.nearMax(:sphere) => [[ 72, -44 ], 5])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$nearSphere" => [ 72, -44 ], "$maxDistanceSphere" => 5 } }
    end
  end  

  
  describe "#withinBox" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    
    let(:criteria) do
      base.where(:locations.withinBox => [point_a, point_b])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$box" => [point_a, point_b] } } }
    end
  end  

  describe "#withinBox hash box" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    let(:box) do
      {:lower_left => point_a, :upper_right => point_b}
    end
    
    let(:criteria) do
      base.where(:locations.withinBox => box)
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$box" => [point_a, point_b] } } }
    end
  end  

  describe "#withinBox Struct box" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    let(:box) do
      b = (Struct.new :lower_left, :upper_right).new
      b.lower_left = point_a
      b.upper_right = point_b
      b
    end
    
    let(:criteria) do
      base.where(:locations.withinBox => box)
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$box" => [point_a, point_b] } } }
    end
  end  

  describe "#withinBox sphere" do  
    let(:point_a) { [ 72, -44 ] }
    let(:point_b) { [ 71, -45 ] }      
    
    let(:criteria) do
      base.where(:locations.withinBox(:sphere) => [point_a, point_b])
    end
  
    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$boxSphere" => [point_a, point_b] } } }
    end
  end  
  
  describe "#withinCenter" do  
    let(:criteria) do
      base.where(:locations.withinCenter => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end  

  describe "#withinCenter hash circle" do  
    let(:center) { [ 72, -44 ] }
    let(:box) do
      {:center => center, :radius => 5}
    end
    
    let(:criteria) do
      base.where(:locations.withinCenter => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end  

  describe "#withinBox Struct circle" do  
    let(:center) { [ 71, -45 ] }      
    let(:box) do
      b = (Struct.new :center, :radius).new
      b.center = center
      b.radius = radius
      b
    end
    
    let(:criteria) do
      base.where(:locations.withinCenter => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end  


  describe "#withinCenter sphere" do  
    let(:criteria) do
      base.where(:locations.withinCenter(:sphere) => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :locations => { "$within" => { "$centerSphere" => [[ 72, -44 ], 5]} }}
    end
  end  

end
