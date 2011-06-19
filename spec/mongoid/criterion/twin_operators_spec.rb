require "mongoid/spec_helper"

def twinop_class
  Mongoid::Criterion::TwinOperators
end

describe Mongoid::Criterion::TwinOperators do  

  let(:twin_op) do
    twinop_class.new :op_a => 'near', :op_b => 'maxDistance', :key => :location
  end

  describe "#initializer" do    
    it 'should have the instance vars set' do
      twin_op.op_a  = 'near'
      twin_op.op_b  = 'maxDistance'
      twin_op.key   = :location
    end      
  end

  describe "#to_query" do    
    describe 'array arg' do
      it "should return the mongo query hash" do
        arg = [[72, -44], 5]
        twin_op.to_mongo_query(arg).should == { :location => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
      end
    end

    describe 'hash arg' do
      it "should return the mongo query hash" do
        arg = {:point => [72, -44], :distance => 5}
        twin_op.to_mongo_query(arg).should == { :location => { "$near" => [ 72, -44 ], "$maxDistance" => 5 } }
      end
    end
  end # to_query
end