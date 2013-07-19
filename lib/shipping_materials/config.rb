module ShippingMaterials
  class Config
    class << self
      attr_writer :save_path

      def base_context
        @base_context || :objects
      end

      def base_context=(bc)
        @base_context = bc.to_sym
      end

      def save_path
        @save_path || '.'
      end
    end
  end
end