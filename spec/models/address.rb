class Address
  include Mongoid::Document
  extend Mongoid::Geo::Locatable

  field :location, :type => Array, :geo => true
  geo_index :location

end
