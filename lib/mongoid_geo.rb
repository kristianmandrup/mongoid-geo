require 'mongoid/geo'

Mongoid::Geo.mongo_db_version = 1.8
Mongoid::Geo.spherical = false