# encoding: utf-8
module Mongoid #:nodoc:
  module Extensions #:nodoc:
    module Hash #:nodoc:
      module CriteriaHelpers #:nodoc:
        def expand_complex_criteria
          hsh = {}
          each_pair do |k,v|
            case k
            when Mongoid::Criterion::Complex
              hsh[k.key] ||= {}
              hsh[k.key].merge!(k.make_hash(v))
            when Mongoid::Criterion::OuterOperator
              hsh[k.key] ||= {}
              hsh[k.key].merge!(k.make_hash(v))
            when Mongoid::Criterion::TwinOperator
              raise "TwinOperator expects an array with a value for each of the twin operators" if !v.kind_of(Array) && !v.size == 2
              hsh[k.key] ||= {}              
              hsh[k.key].merge!(k.make_hash(v))
            else
              hsh[k] = v
            end
          end
          hsh
        end
      end
    end
  end
end