# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name                        = "mongoid_geo" 
  s.authors                     = ["Kristian Mandrup"]
  s.email                       = ["kmandrup@gmail.com"]  
  s.summary                     = "Adds extra convenience methods for geo-spatial operations etc."
  s.description                 = "Geo spatial extension on Mongoid 2, to add more geo-spatial capabilities"
  s.homepage                    = "https://github.com/kristianmandrup/mongoid-geo"
  s.required_rubygems_version   = ">= 1.3.6"
  s.files                       = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.textile"]

  s.add_development_dependency  "rspec",          '>= 2.4'

  s.add_dependency              "mongoid",        '>= 2.0.0.rc.6'
  s.add_dependency              "bson_ext",       '>= 1.1.6'

  s.add_dependency              'activesupport',  '>= 3.0.4'
  s.add_dependency              'hashie',         '>= 0.4.0'   # https://github.com/okiess/mongo-hashie ???

  s.version                     = "0.3.0"
end