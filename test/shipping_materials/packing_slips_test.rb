require File.expand_path('../../header', __FILE__)

class PackingSlipsTest < TestCase
  def test_basic_stuff
    ps = ShippingMaterials::PackingSlips.new(orders, './test/files/template.mustache')
  end
end