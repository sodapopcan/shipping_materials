require File.expand_path('../../header', __FILE__)

class PackagerTest < TestCase
  def setup
    @packager = ShippingMaterials::Packager.new
  end

  def test_dsl
    ShippingMaterials.config do |config|
      config.save_path = 'test/files/'
    end

    @packager.package orders do
      packing_slips pdf: './test/files/template.mustache'

      sort(:line_items) {
        rule { type == 'Vinyl' }
      }

      group 'canada_standard_post' do
        filter { shipping_method == 'std' && country == 'CA' }

        labels :headers => true do
          row :order_id => :id,
              :name     => :name,
              :static_fields => 'Use a string'

          row :line_items => [ 'H', :id, :name, :quantity, :price ]
        end
      end

      group 'international_ups_expedited' do
        filter { shipping_method == 'UPSexp' && !%w(US CA).include?(country) }

        labels :entension => 'txt' do
          row [ :id, :name ]
        end
      end

      group 'all_canadian_orders' do
        filter { country == 'CA' }

        labels do
          row [ :id, :name ]
        end
      end

      group 'all_us_orders' do
        filter { country == 'US' }

        labels do
          row [ :id, :name ]
        end
      end
    end
  end
end
