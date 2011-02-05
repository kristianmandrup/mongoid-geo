class Person
  include Mongoid::Document

  field       :name
  embeds_many :addresses
    
  index :addresses
  index :name
end