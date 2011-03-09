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

RSpec.configure do |config|
  # config.mock_with :mocha
end


