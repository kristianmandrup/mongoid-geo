require "mongoid/spec_helper"

def nestop_class
  Mongoid::Criterion::NestedOperators
end

describe Mongoid::Criterion::TwinOperators do  

  let(:nested_op) do
    nestop_class.new :op_a => 'near', :op_b => 'maxDistance', :key => :location
  end

  describe "#initializer" do    
    it 'should have the instance vars set' do
      nested_op.op_a  = 'near'
      nested_op.op_b  = 'maxDistance'
      nested_op.key   = :location
    end      
  end

  describe "#to_query" do    
    describe 'array arg' do
      it "should return the mongo query hash" do
        point_a = [72, -44]
        point_b = [74, 47]

        arg = [point_a, point_b]

        nested_op.to_query(arg).should == { :location => { "$within" => { "$box" => [point_a, point_b] } } }
      end
    end

    describe 'hash arg' do
      it "should return the mongo query hash" do
        point_a = [72, -44]
        point_b = [74, 47]

        arg = {:lower_left => point_a, :upper_right => point_b]

        nested_op.to_query(arg).should == { :location => { "$within" => { "$box" => [point_a, point_b] } } }
      end
    end
  end # to_query
end