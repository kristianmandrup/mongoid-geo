require "rspec"
require "mocha"
require "mongoid"
require "lib/mongoid_geo"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

LOGGER = Logger.new($stdout)

Mongoid.configure do |config|
  name = "mongoid_test"
  config.master = Mongo::Connection.new.db(name)
  config.logger = nil
end

Mongoid::Geo.setup do |config|
  config.default_units = :miles
  config.distance_formula = :spherical
  config.mongo_db_version = 1.8
end

RSpec.configure do |config|
  config.mock_with(:mocha)
  config.after(:suite) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end

  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include RSpec::Matchers

  # == Mock Framework
  config.mock_with :rspec
end

