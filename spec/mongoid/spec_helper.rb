require 'rspec'
require 'mongoid'
require 'mongoid_geo'
require 'mongoid/db_helper'                 

require "mongoid/helper/inflections"
require "mongoid/helper/field"

require 'models/address'
require 'models/person'
Address.create_indexes

# require 'geo_calc'
