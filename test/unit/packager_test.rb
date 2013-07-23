require 'test_helper'

module ShippingMaterials
	self.config do |config|
		config.save_path     = '/Users/andrwe/shipping_materials'
		config.gzip_file_name = proc { "shipmat#{Time.now.to_i}" }
		config.use_s3        = true
		config.s3_bucket     = 'shipmaterials.gelaskins.com'
		config.s3_access_key = ENV['AWS_SECRET_ACCESS_KEY']
		config.s3_secret     = ENV['AWS_ACCESS_KEY']
	end

  class PackagerTest < TestCase
    def setup
      @packager = Packager.new
    end

    def test_dsl
      @packager.package orders do
        pdf './test/files/template.mustache'

        sort(:line_items) {
          rule { type == 'Vinyl' }
        }

        group 'canada_standard_post' do
          filter { shipping_method == 'std' && country == 'CA' }

          csv :headers => true do
            row :order_id => :id,
                :name     => :name,
                :static_fields => 'Use a string'

            row :line_items => [ 'H', :id, :name, :quantity, :price ]
          end
        end

        group 'international_ups_expedited' do
          filter { shipping_method == 'UPSexp' && !%w(US CA).include?(country) }

          csv :entension => 'txt' do
            row [ :id, :name ]
          end
        end

        group 'all_canadian_orders' do
          filter { country == 'CA' }

          csv do
            row [ :id, :name ]
          end
        end

        group 'all_us_orders' do
          filter { country == 'US' }

          csv do
            row [ :id, :name ]
          end
        end
      end
    end
  end
end
