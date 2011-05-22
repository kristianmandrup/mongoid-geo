require 'mongoid'
require 'mongoid_geo'
require 'net/http'
require 'active_support'
require 'haversine'
require 'rack'
require 'hashie'
                 
Mongoid.configure.master = Mongo::Connection.new.db('mongoid-geo')

Mongoid.database.collections.each do |coll|
  coll.remove
end

class Location
  include Mongoid::Document

  field :lon_lat, :type => Array

  extend Mongoid::Geo::Near

  geo_index :lon_lat, :create

  def self.search(loc)
    country = "The Netherlands"
    location = [loc, country].compact.join(', ')
    response = ::Net::HTTP.get_response(URI.parse("http://maps.googleapis.com/maps/api/geocode/json?address=#{Rack::Utils.escape(location)}&sensor=false"))
    json = ActiveSupport::JSON.decode(response.body)

    if json["status"] == "OK"
      lon_lat = json["results"][0]["geometry"]["location"]["lng"], json["results"][0]["geometry"]["location"]["lat"]
    else
      return false
    end
    geoNear(lon_lat, :lon_lat)        
  end
end

