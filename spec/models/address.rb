class Address
  include Mongoid::Document
  extend Mongoid::Geo::Near
  
  attr_accessor :mode

  field :address_type
  field :number, :type => Integer
  field :street
  field :city
  field :state
  field :post_code
  field :location, :type => Array, :geo => true

  field :pos, :type => Array, :geo => true, :lat => :latitude, :lng => :longitude

  # key :street

  geo_index :location
end