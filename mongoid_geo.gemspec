# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "mongoid_geo"
  s.summary = "Adds extra convenience methods for geo-spatial operations etc."
  s.description = "Geo spatial extension on Mongoid 2, to add more geo-spatial capabilities"
  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.add_dependency "mongoid", '>= 2.0.0.rc.6'
  s.add_dependency "bson_ext", '>= 1.1.6'
  s.version = "0.1.0"
end