require File.expand_path('../../header', __FILE__)

class GroupTest < TestCase
  def setup
    @group = ShippingMaterials::Group.new('basename', orders)
  end

  def test_filter
    @group.filter { country == 'CA' }

    assert_equal 4, @group.objects.size,
      "The number of groups should be 1"
  end

  def test_labels
    @group.filter { country == 'CA' }

    @group.labels {
    }
  end
end