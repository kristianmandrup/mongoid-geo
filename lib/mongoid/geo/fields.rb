module Mongoid #:nodoc
  # This module defines behaviour for fields.
  module Fields
    module ClassMethods #:nodoc
      def create_accessors(name, meth, options = {})
        generated_field_methods.module_eval do
          define_method(meth) { read_attribute(name) }
          options
          define_method("#{meth}=") do |value| 
            value = if options[:type] == Array && options[:geo]
              value.kind_of?(String) ? value.split(",") : value
            end.map(&:to_f)
            write_attribute(name, value) 
          end
          define_method("#{meth}?") do
            attr = read_attribute(name)
            (options[:type] == Boolean) ? attr == true : attr.present?
          end
        end
      end
    end
  end
end