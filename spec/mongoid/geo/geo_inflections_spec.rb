require "mongoid/spec_helper"

describe Mongoid::Criterion::Inclusion do

  let(:base) do
    Mongoid::Criteria.new(Person)
  end

  def near calc
    Criterion::Complex.new(:operator => get_op(calc, 'near'), :key => self)          
  end

  def nearMax calc
    Criterion::TwinOperators.new(:op_a => get_op(calc, 'near'), :op_b => get_op(calc, 'maxDistance'), :key => self)
  end

  def withinBox calc
    Criterion::InnerKey.new(:outer_op => 'within', :operator => get_op(calc, 'box'), :key => self)
  end

  def withinCenter calc
    Criterion::InnerKey.new(:outer_operator => 'within', :operator => get_op(calc, 'center'), :key => self)
  end 

  
  describe "#nearSphere" do

    let(:criteria) do
      base.nearSphere(:field => [ 72, -44 ])
    end

    it "adds the $nearSphere modifier to the selector" do
      criteria.selector.should ==
        { :field => { "$nearSphere" => [ 72, -44 ] } }
    end
  end  

  describe "#nearMax" do

    let(:criteria) do
      base.nearMax(:field => [[ 72, -44 ], 5])
    end

    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :field => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
    end
  end  

  describe "#withinBox" do

    let(:criteria) do
      base.withinBox(:field => [[ 72, -44 ], [ 72, -44 ]])
    end

    it "adds the $near and $maxDistance modifiers to the selector" do
      criteria.selector.should ==
        { :field => { "$within" => { "$box" => [[ 72, -44 ], [ 72, -44 ]]} }
    end
  end  

  describe "#withinCenter" do

    let(:criteria) do
      base.withinCenter(:field => [[ 72, -44 ], 5])
    end

    it "adds the $within and $center modifiers to the selector" do
      criteria.selector.should ==
        { :field => { "$within" => { "$center" => [[ 72, -44 ], 5]} }
    end
  end  
end

end