# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Hash
      autoload :CriteriaHelpers,    'mongoid/extensions/hash/geo_criteria_helpers'
    end

    module Symbol
      autoload :Inflections,        'mongoid/extensions/symbol/geo_inflections'
    end
  end
end