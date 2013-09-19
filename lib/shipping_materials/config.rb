module ShippingMaterials
  class Config
    class << self
      attr_accessor :s3_bucket,
                    :s3_access_key,
                    :s3_secret,
                    :gzip_file_name

      def save_path=(save_path)
        @save_path = save_path.sub(/(\/)+$/, '')
      end

      def save_path
        @default   ||= Time.now.to_i
        @save_path || "/tmp/shipping_materials#{@default}"
      end

      def use_s3?
        @s3_bucket
      end

      def use_gzip?
        @gzip_file_name
      end
    end
  end
end