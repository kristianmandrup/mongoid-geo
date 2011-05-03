require 'mongoid/geo'

Mongoid::Geo.mongo_db_version = 1.5
Mongoid::Geo.spherical = false