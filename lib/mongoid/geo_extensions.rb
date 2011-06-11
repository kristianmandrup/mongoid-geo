# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Hash
      autoload :CriteriaHelpers,    'mongoid/extensions/hash/criteria_helpers'
    end

    module Symbol
      autoload :Inflections,        'mongoid/extensions/symbol/inflections'
    end
  end
end