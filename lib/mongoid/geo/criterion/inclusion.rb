# encoding: utf-8
module Mongoid #:nodoc:
  module Criterion #:nodoc:
    module Inclusion
      # Adds a criterion to the +Criteria+ that specifies values to do
      # geospacial searches by. The field must be indexed with the "2d" option.
      #
      # @example Adding the criterion.
      #   criteria.near(:field1 => [30, -44])
      #
      # @param [ Hash ] attributes The fields with lat/long values.
      #
      # @return [ Criteria ] A new criteria with the added selector.
      def nearSphere(attributes = {})
        update_selector(attributes, "$nearSphere")
      end
    end
  end
end