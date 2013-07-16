require 'test/unit'
require 'debugger'

require File.expand_path('../data.rb', __FILE__)

require File.expand_path('../../lib/shipping_materials.rb', __FILE__)

ShippingMaterials.config do |config|
  config.save_path = './test/files'
end

class TestCase < Test::Unit::TestCase
  include TestData
end
