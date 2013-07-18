require File.expand_path('../../header', __FILE__)

class GroupTest < TestCase
  def setup
    @group = ShippingMaterials::Group.new('basename', orders)
  end

  def test_filter
    @group.filter { country == 'CA' }

    assert_equal 4, @group.objects.size,
      "The number of groups should be 4"
  end

  def test_labels
    @group.filter { name == 'Derek' }
    assert_equal 1, @group.objects.size,
      "The number of Groups should be 1"

    @group.labels {
      row :order_id => :id,
          :name     => :name,
          :static   => 'Hello'
    }

    assert_equal "3,Derek,Hello\n", @group.labels.first.to_csv,
      "The Group#label method is borked"
  end

  def test_sort_mixin
    @group.filter { country == 'CA' }

    @group.sort {
      rule { line_items.detect {|li| li.type == 'Vinyl' }}
      rule { name == 'Miller' }
    }

    @group.sort!

    assert_equal %w( Andrew J.M. Miller Riley ),
                @group.objects.map {|o| o.name },
                "Sortable Mixin not working"
  end
end