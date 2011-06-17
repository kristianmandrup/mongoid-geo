class Person
  include Mongoid::Document

  field       :name
    
  index :name
end
