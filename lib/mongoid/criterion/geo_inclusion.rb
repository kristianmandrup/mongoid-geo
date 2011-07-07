module Mongoid #:nodoc:
  module Criterion #:nodoc:
    module Inclusion
      def near_sphere(attributes = {})
        update_selector(attributes, "$nearSphere")
      end
    end
  end
end
