require "mongoid/spec_helper"

describe Mongoid::Extensions::Symbol::Inflections do
  include InflectionsHelper
  
  describe "#nearSphere" do
    let(:criteria) do
      base.where(:location.nearSphere => [ 72, -44 ])
    end

    it "returns a selector matching a ne clause" do
      criteria.selector.should ==
        { :location => { "$nearSphere" => [ 72, -44 ] } }
    end
  end
end
