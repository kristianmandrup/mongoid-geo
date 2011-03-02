$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'location'

Location.create(:lon_lat => [45, 11])
Location.create(:lon_lat => [46, 12])

Location.collection.create_index([['lon_lat', Mongo::GEO2D]], :min => -180, :max => 180)

puts Location.search('Amsterdam')  
