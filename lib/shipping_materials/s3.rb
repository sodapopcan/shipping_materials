module ShippingMaterials
  class S3
    begin
      require 'aws-sdk'
    rescue LoadError => e
      e.message << " (You may need to install the aws-sdk gem)"
      raise e
    end unless defined?(::AWS::Core)

    def initialize
      @bucket = self.s3.buckets[Config.s3_bucket]
    end

    def write(key, fp)
      @bucket.objects.create(key, fp)
    end

    def s3
      @s3 ||= AWS::S3.new(access_key_id: Config.s3_access_key,
                          secret_access_ket: Config.s3_secret)
    end
  end
end