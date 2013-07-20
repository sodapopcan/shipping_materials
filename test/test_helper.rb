require 'test/unit'
require 'data'
require 'shipping_materials'

ShippingMaterials.config do |config|
  config.save_path = './test/files'
end

module ShippingMaterials
  class TestCase < Test::Unit::TestCase
    include TestData
  end
end
