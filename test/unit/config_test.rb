require 'test_helper'

module ShippingMaterials
  class ConfigTest < TestCase
    def test_config
      ShippingMaterials.config do |config|
        config.save_path = './test/files'
      end

      assert_equal './test/files', ShippingMaterials::Config.save_path,
        "Config variables are not being set"
    end
  end
end