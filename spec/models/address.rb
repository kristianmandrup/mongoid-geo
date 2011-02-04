class Address
  include Mongoid::Document

  attr_accessor :mode

  field :address_type
  field :number, :type => Integer
  field :street
  field :city
  field :state
  field :post_code
  field :latlng, :type => Array
  key :street
  # embeds_many :locations
  # embedded_in :addressable, :polymorphic => true do

  # accepts_nested_attributes_for :locations
end