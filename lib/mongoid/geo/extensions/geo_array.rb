module GeoArray
  def to_geo
    self.geo_point.to_lng_lat
  end
end

[String, Hash].each do |core_class|
  core_class.send :include, GeoArray
end
