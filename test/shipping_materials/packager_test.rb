require File.expand_path('../../header', __FILE__)

class PackagerTest < TestCase
  def setup
    @packager = ShippingMaterials::Packager.new
  end

  # def test_format
  #   @packager.package(orders) { format :pdf => 'path/to/template' }

  #   assert_block "Format should have type and template" do
  #     @packager.format == :pdf && @packager.template == 'path/to/template'
  #   end
  # end

  # def test_packaging_multiple_groups
  #   @packager.package(orders) do
  #     group 'canada_standard_post'
  #     group 'united_states_ups'
  #     group 'international_ups_expedited'
  #   end

  #   assert_equal 3, @packager.groups.size,
  #               "Multiple groups are borked"
  # end

  # def test_group_filter
  #   @packager.package orders do
  #     group 'canada_standard_post' do
  #       filter { shipping_method == 'std' && country == 'CA' }
  #     end
  #   end

  #   assert_block "Shipping method didn't filter" do
  #     @packager.groups.first.objects.size > 0
  #   end
  # end

  # def test_group_labels
  #   @packager.package orders do
  #     group 'canada_standard_post' do
  #       filter { shipping_method == 'std' && country == 'CA' }
  #       labels(:extension => 'csv', :headers => true)
  #     end
  #   end

  #   assert_block "Label options are not getting set" do
  #     labels = @packager.groups.first.labels
  #     labels.first.extension == 'csv' && labels.first.headers?
  #   end
  # end

  def test_entire_dsl
    ShippingMaterials.config do |config|
      config.save_path = 'test/files/'
    end

    @packager.package orders do
      packing_slips pdf: './test/files/template.mustache'

      sort {
        rule(:line_items) { type == 'Vinyl' }
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

    # assert_equal [:object, :line_items],
    #             @packager.groups.first.labels.first.row_maps.keys,
    #             "Row maps aren't getting keyed"
  end
end
