Dir["lib/shipping_materials/mixins/*.rb"].each {|f| require f }
Dir["lib/shipping_materials/*.rb"       ].each {|f| require f }

module ShippingMaterials
  def self.config
    yield Config
  end
end
