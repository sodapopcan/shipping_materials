module ShippingMaterials
  class Config
    class << self
      attr_writer :save_path, :gzip_file_name

      attr_accessor :s3_bucket,
                    :s3_access_key,
                    :s3_secret,
                    :use_s3

      def base_context
        @base_context || :objects
      end

      def base_context=(bc)
        @base_context = bc.to_sym
      end

      def save_path(save_path)
        @save_path = save_path.sub(/(\/)+$/, '')
      end

      def save_path
        @default   ||= Time.now.to_i
        @save_path || "/tmp/shipping_materials#{@default}"
      end

      def use_s3?
        @use_s3
      end

      def use_gzip?
        @gzip_file_name
      end

      def gzip_file_name(gzip_file_name)
        @gzip_file_name = gzip_file_name + '.tar.gz.'
      end

      def gzip_file_name(*args)
        if @gzip_file_name.is_a? Proc
          @gzip_file_name = "#{@gzip_file_name.call(*args).to_s}.tar.gz"
        elsif @gzip_file_name.is_a? String
          @gzip_file_name
        end
      end
    end
  end
end