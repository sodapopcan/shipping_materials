require "shipping_materials/version"

module ShippingMaterials
  def self.config
    yield Config
  end
end
