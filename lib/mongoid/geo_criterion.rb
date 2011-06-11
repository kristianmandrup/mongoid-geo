# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    autoload :Complex,          'mongoid/criterion/complex'
    autoload :Inclusion,        'mongoid/criterion/inclusion'
    autoload :NestedOperators,  'mongoid/criterion/nested_operators'
    autoload :TwinOperators,    'mongoid/criterion/twin_operators'
  end
end