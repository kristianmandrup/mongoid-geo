source "http://rubygems.org"

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

gem 'mongoid',        '>= 2.0.1' #, :git => 'git://github.com/mongoid/mongoid.git' # added Field.option recently (https://github.com/mongoid/mongoid/pull/921)

gem "bson",           '>= 1.3',  :platforms => [:jruby] # for non jruby apps, require bson_ext in your Gemfile to boost performance
gem "bson_ext",       '>= 1.3',  :platforms => [:mri]
gem 'activesupport',  '>= 3'

# default distance calculator
gem 'haversine',      '>=0.3'

group :test, :development do
  gem 'geo_point',    '~> 0.2.3'
  gem 'geo-distance', '~> 0.1.2'  
  gem 'geo_vectors',  '~> 0.6.1'  
  
  
  gem 'rspec',        '>=2.4'
  gem 'bundler',      '>=1'
  gem 'jeweler',      '>=1.5'
  gem 'rdoc',         '>=3.6'
end

group :test do
  gem 'rails',        '>=3.0'
  gem 'rspec-rails',  '>=2.6'
  gem 'capybara',     '>=0.4'
end
