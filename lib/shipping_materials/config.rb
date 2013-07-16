module ShippingMaterials
  class Config
    class << self
      attr_writer :save_path

      def save_path
        @save_path || '.'
      end
    end
  end
end