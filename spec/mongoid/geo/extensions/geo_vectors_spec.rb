require "mongoid/spec_helper"

describe 'Using Geo Vectors' do
  before do
    Mongoid::Geo.enable_extension! :geo_vectors
  end

  let(:address) do
    Address.new        
  end

  let(:hash_geo_point) do
    {:lng => -44, :lat => 72}.geo_point
  end  

  # Note: GeoVectors use [lat, lng] format  
  let(:point_vector) do
    # 3 lng, -2 lat
    [3, -2].vector
  end  

  describe "Adding GeoVector to GeoPoint" do
    it "should apply vector to point" do
      new_point = hash_geo_point + point_vector
      address.location = new_point.to_lng_lat      
      address.location.should == [-46, 75] # lng, lat
    end
  end

  describe "Adding GeoVector to Location" do
    it "should apply vector to location point directly" do
      address.location = hash_geo_point.to_lng_lat
      address.location.should == [-44, 72]       
      address.location.add!(point_vector)
      address.location.should == [-46, 75]
    end
  end
  
  describe "Subtracting GeoVector from Location" do
    it "should apply inverse vector to location point directly" do
      address.location = hash_geo_point.to_lng_lat
      address.location.should == [-44, 72]       
      address.location.sub!(point_vector)
      address.location.should == [-42, 69]
    end
  end
  
  describe "Add GeoVectors to Location" do
    let(:geo_vectors) do
      point_vector << [32, 2.km].vector
    end
  
    it 'should create a collection of vectors' do 
      geo_vectors.should be_a(GeoVectors)      
      geo_vectors.vectors.size.should == 2 # will soon be a :size proxy on GeoVectors
    end
  
    it "should apply collection of vectors to location point directly" do
      address.location = hash_geo_point.to_lng_lat
      address.location.should == [-44, 72]       
      address.location.add!(geo_vectors)    
  
      address.location_lat.should be_between(74, 76)
      address.location_lng.should be_between(-46, -45)
    end
  end  
end