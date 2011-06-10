require 'rspec'
require 'mongoid'
require 'mongoid_geo'
                 
Mongoid.configure.master = Mongo::Connection.new.db('mongoid-geo')

Mongoid.database.collections.each do |coll|
  coll.remove
end

# require 'mongoid/geo/fields'
require 'models/address'
require 'models/person'

def clean_database!
  Mongoid.database.collections.each do |coll|
    coll.remove
  end
end  

RSpec.configure do |config|
  config.after :each do
    clean_database!
  end
end

def set_server_version version
  Mongoid::Geo::Config.server_version = version
end

def get_server_version
  Mongoid::Geo::Config.server_version
end

