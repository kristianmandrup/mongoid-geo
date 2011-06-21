# See: https://github.com/mongoid/mongoid/pull/921

# Add Mongoid::Field.option for custom field options
# - This allows users of Mongoid to define custom field options, and execute
#   handlers when that option is provided.

# Field changes to Fields from mongoid 2.0 to mongoid 2.1
field = (defined?(Mongoid::Field)) ? Mongoid::Field : Mongoid::Fields
field.option :geo do |model,field,options|
  options = {} unless options.kind_of?(Hash)
  model.index([[ field.name, Mongo::GEO2D ]]) unless options[:index] == false
  model.class_eval {
    attr_accessor :from_point, :from_hash, :distance
    lat_meth = options[:lat] || "#{field.name}_lat"
    lng_meth = options[:lng] || "#{field.name}_lng"

    define_method(lng_meth) do
      write_attribute(field.name, [nil,nil]) if !read_attribute(field.name) || read_attribute(field.name).empty?
      read_attribute(field.name)[0]
    end
    define_method(lat_meth) do 
      write_attribute(field.name, [nil,nil]) if !read_attribute(field.name) || read_attribute(field.name).empty?
      read_attribute(field.name)[1]
    end

    define_method "#{lng_meth}=" do |value|
      write_attribute(field.name, [nil,nil]) if !read_attribute(field.name) || read_attribute(field.name).empty?
      send(field.name)[0] = value
    end

    define_method "#{lat_meth}=" do |value|
      write_attribute(field.name, [nil,nil]) if !read_attribute(field.name) || read_attribute(field.name).empty?
      send(field.name)[1] = value
    end

    define_method field.name do |*args|
      if args.size == 2
        [read_attribute(field.name)[Mongoid::Geo::lng_lat[args[0]]],read_attribute(field.name)[Mongoid::Geo::lng_lat[args[1]]]]
      else
        read_attribute(field.name)
      end
    end

  }
end
