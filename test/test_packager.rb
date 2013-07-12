require 'test/unit'

require 'debugger'

require File.expand_path('../data.rb', __FILE__)

Dir.glob('lib/shipping_materials/*.rb').each do |file|
  require File.expand_path("../../#{file}", __FILE__)
end

class PackagerTest < Test::Unit::TestCase
  include TestData

  def setup
    @packager = ShippingMaterials::Packager.new
  end

  def test_format
    @packager.package(orders) { format :pdf => 'path/to/template' }

    assert_block "Format should have type and template" do
      @packager.format == :pdf && @packager.template == 'path/to/template'
    end
  end

  def test_group
    @packager.package(orders) { group 'canada_standard_post' }

    assert_equal 1, @packager.groups.size,
                "The number of groups should be 1"
    assert_equal 'canada_standard_post', @packager.groups.first.filename,
                "Group filename not getting set"
  end

  def test_multiple_groups
    @packager.package(orders) do
      group 'canada_standard_post'
      group 'united_states_ups'
      group 'international_ups_expedited'
    end

    assert_equal 3, @packager.groups.size,
                "Multiple groups are borked"
  end

  def test_group_filter
    @packager.package orders do
      group 'canada_standard_post' do
        filter { shipping_method == 'std' && country == 'CA' }
      end
    end

    assert_block "Shipping method didn't filter" do
      @packager.groups.first.objects.size > 0
    end
  end

  def test_group_labels
    @packager.package orders do
      group 'canada_standard_post' do
        filter { shipping_method == 'std' && country == 'CA' }
        labels(:extension => 'csv', :headers => true)
      end
    end

    assert_block "Label options are not getting set" do
      labels = @packager.groups.first.labels
      labels.first.extension == 'csv' && labels.first.headers?
    end
  end

  def test_row_should_set_headers
    @packager.package orders do
      group 'canada_standard_post' do
        filter { shipping_method == 'std' && country == 'CA' }
        labels :extension => 'csv', :headers => true do
          row :order_id => :id,
              :name     => :name,
              :static_field => 'Use a string'
        end
      end
    end

    assert_equal ['order_id', 'name', 'static_field'],
                @packager.groups.first.labels.first.headers,
                "Label headers are wrong"
  end
end
