# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    autoload :Complex,          'mongoid/criterion/geo_complex'
    autoload :Inclusion,        'mongoid/criterion/geo_inclusion'
    autoload :NestedOperators,  'mongoid/criterion/nested_operators'
    autoload :TwinOperators,    'mongoid/criterion/twin_operators'
  end
end