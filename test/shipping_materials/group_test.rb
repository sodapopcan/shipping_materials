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

  def test_line_item_sort_mixin
    @group.filter { name == 'Derek' }

    @group.sort(:line_items) {
      rule { type == 'Vinyl' }
      rule { type == 'CD'    }
    }

    @group.sort!

    assert_equal [ 4, 12, 9, 10, 11, 15, 13, 14 ], 
                @group.objects.first.line_items.map {|li| li.id },
                "Line items are not sorting"
  end
end