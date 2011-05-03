module Mongoid #:nodoc
  # This module defines behaviour for fields.
  module Fields
    module ClassMethods #:nodoc
      def create_accessors(name, meth, options = {})
        generated_field_methods.module_eval do
          if [ Time, DateTime ].include?(options[:type])
            define_method(meth) { Time.get(read_attribute(name)) }
          else
            define_method(meth) { read_attribute(name) }
          end

          if options[:type] == Array && options[:geo]            
            lat_meth = options[:lat] || "lat"
            lng_meth = options[:lng] || "lng"

            define_method(lat_meth) { read_attribute(name).try(:[], Mongoid::Geo.lat_index) }
            define_method(lng_meth) { read_attribute(name).try(:[], Mongoid::Geo.lng_index) }
                        
            define_method "#{lat_meth}=" do |value|
              send(name)[Mongoid::Geo.lat_index] = value
            end            
            define_method "#{lng_meth}=" do |value|
              send(name)[Mongoid::Geo.lng_index] = value
            end            
          end

          define_method("#{meth}=") do |value|
            if options[:type] == Array && options[:geo]
              value = case value
              when String
                value.split(",").map(&:to_f)
              when Array
                value.compact.extend(Mongoid::Geo::Point).to_points
              else
                !value.nil? ? value.extend(Mongoid::Geo::Point).to_point : value
              end
              value = value[0..1] if !value.nil?
            end
            value.reverse! if Mongoid::Geo.spherical && value
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