require "mongoid/spec_helper"

Address.collection.create_index([['location', Mongo::GEO2D]], :min => -180, :max => 180)


Address.create(:location => [45, 11], :city => 'Munich')
Address.create(:location => [46, 12], :city => 'Berlin')
Address.create(:location => [46, 11], :city => 'Berlin')

describe Mongoid::Geo::Near do

  let(:address) do
    Address.new        
  end  

  describe "geoNear" do
    describe 'Mongo DB version 1.7+ uses internal distance calculations' do
      it "should return models with distances not calculated by haversine" do
        Mongoid::Geo.mongo_db_version = 1.7
        
        address.location = "23.5, -47"
        hashies = Address.geoNear(address, :location)

        models = hashies.to_models

        models.first.distance.should == hashies.first.distance
        
        models.first.lat.should == 45
        
        # if Mongo DB < 1.7 installed but Mongoid Geo configured for 1.7 
        #models.map(&:distance).first.should == nil

        # if Mongo DB 1.7 installed but Mongoid Geo configured for 1.7 
        models.map(&:distance).first.should be_within(0.0001).of(61.85669195123871) 
      end
    end
    
    context "mongo_db_version is 1.5" do
      
      before(:each) do
        Mongoid::Geo.mongo_db_version = 1.5
        address.location = "23.5, -47"
        @hashies = Address.geoNear(address, :location)
      end
      describe '#to_models' do
        it "should return models" do
          pending "I'm current useing mongodb > 1.5,so can't make this pass"
          models = @hashies.to_models
          models.first.distance.should == @hashies.first.distance
          models.first.lat.should == 45
          models.map(&:distance).first.should > 1
        end
      end

      describe '#to_model' do
        it "should return model" do
          pending "I'm current useing mongodb > 1.5,so can't make this pass"
          hashie = @hashies.first

          my_model = hashie.to_model       

          my_model.distance.should == hashie.distance

          my_model.lat.should == 45      
          first_dist = my_model.distance
          my_model.distance.should > 1
          lambda {my_model.distance = 500}.should raise_error
          my_model.distance.should > 1        

          address.location = "27.5, 12"        
          my_model = Address.geoNear(address, :location, :num => 1).first.to_model
          my_model.distance.should_not == first_dist        
        end
      end
    end
   
  end
end