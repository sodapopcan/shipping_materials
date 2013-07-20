require 'test_helper'

module ShippingMaterials
  class PackingSlipsTest < TestCase
    def test_basic_stuff
      ps = ShippingMaterials::PackingSlips.new(orders, './test/files/template.mustache')
    end
  end
end