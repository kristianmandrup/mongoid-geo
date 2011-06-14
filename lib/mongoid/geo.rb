require 'mongoid/geo/core_ext'
require 'mongoid/geo/config'
require 'mongoid/geo/macros'
require 'mongoid/geo/queries'

module Mongoid
  module Geo    
    def self.config &block
      yield Config if block
      Config
    end    
  end
end

