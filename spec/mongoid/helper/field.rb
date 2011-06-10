module FieldHelper
  let(:address) do
    Address.new        
  end

  let(:point) do
    b = (Struct.new :lat, :lng).new
    b.lat = 72
    b.lng = -44
    b
  end  

  let(:location) do
    a = (Struct.new :location).new
    a.location = point
    a
  end  

  let(:position) do
    a = (Struct.new :position).new
    a.position = point
    a
  end  


  let(:other_point) do
    b = (Struct.new :latitude, :longitude).new
    b.latitude = 72
    b.longitude = -44
    b
  end
end