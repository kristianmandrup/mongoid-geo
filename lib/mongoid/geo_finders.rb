module Mongoid #:nodoc:
  module Finders
    def geo_near(*args)
      criteria.send(:geo_near, *args)
    end
  end
end
