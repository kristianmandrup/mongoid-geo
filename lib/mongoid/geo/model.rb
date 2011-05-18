module Mongoid
  module Geo
    module Model
      def to_model
        m = klass.where(:_id => _id).first.extend(Mongoid::Geo::Distance)
        m.distance = distance
        m
      end
    end
  end
end
