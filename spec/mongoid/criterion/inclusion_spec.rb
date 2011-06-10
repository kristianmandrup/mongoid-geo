require "mongoid/geo_spec_helper"

describe Mongoid::Criterion::Inclusion do

  let(:base) do
    Mongoid::Criteria.new(Address)
  end

  describe "#near" do

    let(:criteria) do
      base.nearSphere(:location => [ 72, -44 ])
    end

    it "adds the $near modifier to the selector" do
      criteria.selector.should ==
        { :location => { "$nearSphere" => [ 72, -44 ] } }
    end
  end
end