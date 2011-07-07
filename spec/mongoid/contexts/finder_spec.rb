require "mongoid/spec_helper"

# make sure mongoid-geo does not break mongoid
describe Mongoid::Contexts::Mongo do

  before(:each) do
    Address.create(:location => [45, 11], :city => 'Munich')
    Address.create(:location => [46, 12], :city => 'Berlin')
  end
  
  it "can count" do
    Address.count.should    == 2
  end
  
  it "can find using first" do
    Address.first.city.should      == 'Munich'
  end
  
  it "can find useing where" do
    Address.where(:city => 'Munich').first.city.should      == "Munich"
  end
  
  
end