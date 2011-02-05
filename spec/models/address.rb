class Address
  include Mongoid::Document

  attr_accessor :mode

  field :address_type
  field :number, :type => Integer
  field :street
  field :city
  field :state
  field :post_code
  field :locations, :type => Array, :geo => true
  key :street

  geo_index :locations
end