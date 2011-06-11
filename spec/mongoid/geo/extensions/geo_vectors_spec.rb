require "mongoid/spec_helper"
require "geo_calc"
require "mongoid/geo/ext/geo_vectors"

# This will also be required for using macros in geo_calc in the near future!
require 'geo_vectors/macros' # USE MACROS!!! - 

describe 'Using Geo Vectors' do
  let(:address) do
    Address.new        
  end

  let(:hash_geo_point) do
    {:lat => 72, :lng => -44}.geo_point
  end  

  # Note: GeoVectors use [lat, lng] format  
  let(:point_vector) do
    [3, -2].vector
  end  

  describe "Adding GeoVector to GeoPoint" do
    it "should apply vector to point" do
      new_point = hash_geo_point + point_vector
      address.location = new_point
      address.location.should == [-46, 75]
    end
  end

  describe "Adding GeoVector to Location" do
    it "should apply vector to location point directly" do
      address.location = hash_geo_point
      address.location.should == [-44, 72]       
      address.location.add!(point_vector)
      address.location.should == [-46, 75]
    end
  end

  describe "Subtracting GeoVector from Location" do
    it "should apply inverse vector to location point directly" do
      address.location = hash_geo_point
      address.location.should == [-44, 72]       
      address.location.sub!(point_vector)
      address.location.should == [-42, 69]
    end
  end
  
  describe "Add GeoVectors to Location" do
    let(:geo_vectors) do
      point_vector << [2.km, 32].vector
    end

    it 'should create a collection of vectors' do 
      geo_vectors.should be_a(GeoVectors)      
      pp geo_vectors
      geo_vectors.vectors.size.should == 2 # will soon be a :size proxy on GeoVectors
    end

    it "should apply collection of vectors to location point directly" do
      address.location = hash_geo_point
      address.location.should == [-44, 72]       
      address.location.add!(geo_vectors)    

      puts "Something is weird here! I think #lat should return 2nd element, not the first! Must be related to update on May 25?"

      pp address.location
      puts "lat: #{address.lat}, lng: #{address.lng}"
      address.lng.should be_between(74, 76)
      address.lat.should be_between(-46, -45)
    end
  end  
end