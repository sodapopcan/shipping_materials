require File.expand_path('../header.rb', __FILE__)

class GroupTest < TestCase
  def setup
    @group = ShippingMaterials::Group.new('filename', orders)
  end

  def test_filter
    @group.filter { country == 'CA' }

    assert_equal 4, @group.objects.size,
                "The number of groups should be 1"
  end
end