require 'test/unit'
require File.expand_path('../data.rb', __FILE__)

class TestTest < Test::Unit::TestCase
  include TestData

  def test_first_order_has_two_line_items
    assert_equal 2, orders.first.line_items.count,
      "Not enough line items in first order"
  end
end
