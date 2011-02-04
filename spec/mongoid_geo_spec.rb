require 'spec_helper'

describe Mongoid::Geo do
  it "should be valid" do
    Mongoid::Geo.should be_a(Module)
  end
end