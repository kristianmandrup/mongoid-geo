module Mongoid
  module Geo
    module Models
      def to_models mode = nil
        distance_hash = Hash[ self.map {|item| [item._id, item.distance] } ]
        from_hash = Hash[ self.map { |item| [item._id, item.fromPoint] } ]

        ret = to_criteria.to_a.map do |m|
          m[:distance] = distance_hash[m._id.to_s]
          m[:fromPoint] = from_hash[m._id.to_s]
          m[:fromHash] = from_hash[m._id.to_s].hash
          m.save if mode == :save
          m
        end
        ret.sort {|a,b| a.distance <=> b.distance}
      end

      def as_criteria direction = nil
        to_models(:save)
        ids = first.klass.all.map(&:_id)
        crit = Mongoid::Criteria.new(first.klass).where(:_id.in => ids, :fromHash => first.fromPoint.hash) 
        crit = crit.send(direction, :distance) if direction
        crit
      end
      
      def to_criteria
        ids = map(&:_id)  
        Mongoid::Criteria.new(first.klass).where(:_id.in => ids).desc(:distance)
      end      
    end
  end
end
