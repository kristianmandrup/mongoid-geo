class Person
  include Mongoid::Document

  field       :name
  embeds_many :addresses, :as => :addressable, :validate => false do
    
  index :addresses
  index :name
end