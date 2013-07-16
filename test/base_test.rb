require File.expand_path('../header', __FILE__)
require File.expand_path('../../lib/shipping_materials.rb', __FILE__)

class ConfigTest < TestCase
  def test_config
    ShippingMaterials.config do |config|
      config.save_path './test/files'
    end

    assert_equal './test/files', ShippingMaterials::Config.save_path,
      "Config variables are not being set"
  end
end