require 'test_helper'

ShippingMaterials.config do |config|
  config.use_s3 = true
  config.s3_bucket     = 'shipmaterials.gelaskins.com'
  config.s3_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  config.s3_secret     = ENV['AWS_ACCESS_KEY']
end

module ShippingMaterials
  class S3Test < TestCase
    def test_s3_write
      html = '<html><body><h1>HELLO MR WORLD<h1></body></html>'
      Storage.write_pdf('canadian_shipping', html)
    end
  end
end