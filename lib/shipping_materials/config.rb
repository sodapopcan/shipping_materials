module ShippingMaterials
  class Config
    class << self
      attr_writer :save_path

      attr_accessor :s3_bucket,
                    :s3_access_key,
                    :s3_secret

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