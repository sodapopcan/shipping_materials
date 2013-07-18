require File.expand_path('../../header', __FILE__)

class SorterTest < TestCase
  def setup
    @sorter = ShippingMaterials::Sorter.new
  end

  def dereks_order
    orders.detect {|o| o.name == 'Derek' }
  end

	def sort_derek(line_items = false)
		if line_items
			@sorter.sort(self.dereks_order.line_items)
		else
			@sorter.sort(self.dereks_order)
		end
	end

  def add_multiple_rules
    @sorter.rule { type == 'CD' }
    @sorter.rule { type == 'Cassette' }
  end

  def test_sort
    add_multiple_rules

    sorted = sort_derek(true)

    assert_equal [9, 10, 11, 15, 13, 14],
                sorted.slice(0, 6).map {|o| o.id },
                "Simple one-rule sort didn't seem to work"
  end

  def test_callbacks
    add_multiple_rules

    @sorter.each_by(:quantity)

    sorted = sort_derek(true)

    assert_equal [15, 10, 9, 11],
                sorted.slice(0, 4).map {|o| o.id },
                "Callback sort is not working"
  end
end