# See: https://github.com/mongoid/mongoid/pull/921

# Add Mongoid::Field.option for custom field options
# - This allows users of Mongoid to define custom field options, and execute
#   handlers when that option is provided.

Mongoid::Field.option :geo do |model,field,options|
  model.index [[ field, Mongo::GEO2D ]], :min => -180, :max => 180
  model.class_eval {
    options = {} unless options.kind_of?(Hash)
    lat_meth = options[:lat] || "#{field}_lat"
    lng_meth = options[:lng] || "#{field}_lng"

    define_method(lng_meth) { read_attribute(field)[0] }
    define_method(lat_meth) { read_attribute(field)[1] }

    define_method "#{lng_meth}=" do |value|
      write_attribute(field, [nil,nil]) if read_attribute(field).empty?
      send(field)[0] = value
    end

    define_method "#{lat_meth}=" do |value|
      write_attribute(field, [nil,nil]) if read_attribute(field).empty?
      send(field)[1] = value
    end
  }
end
