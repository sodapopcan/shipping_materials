require 'test/unit'
require 'debugger'

require File.expand_path('../data.rb', __FILE__)

Dir.glob('lib/shipping_materials/*.rb').each do |file|
  require File.expand_path("../../#{file}", __FILE__)
end

ShippingMaterials.config do |config|
  config.save_path './test/files'
end

class TestCase < Test::Unit::TestCase
  include TestData
end

