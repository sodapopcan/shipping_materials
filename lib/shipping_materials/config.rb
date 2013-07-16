module ShippingMaterials
  class Config
    def self.save_path(save_path = nil)
      @save_path = save_path if save_path
      @save_path || '.'
    end
  end
end