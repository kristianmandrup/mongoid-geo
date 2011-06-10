require "mongoid/geo_spec_helper"

describe Mongoid::Extensions::Symbol::Inflections do  
  describe "#withinCenter" do  
    let(:criteria) do
      base.where(:location.withinCenter => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end  

  describe "#withinCenter hash circle" do  
    let(:center) { [ 72, -44 ] }
    let(:circle) do
      {:center => center, :radius => 5}
    end
    
    let(:criteria) do
      base.where(:location.withinCenter => circle)
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$center" => [[ 72, -44 ], 5]} }}
    end
  end 
  
  describe "#withinCenter sphere" do  
    let(:criteria) do
      base.where(:location.withinCenter(:sphere) => [[ 72, -44 ], 5])
    end
  
    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :location => { "$within" => { "$centerSphere" => [[ 72, -44 ], 5]} }}
    end
  end    
end