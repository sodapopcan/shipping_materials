require File.expand_path('../header', __FILE__)

class LabelTest < UnitTest
  def test_row_array
    @label = ShippingMaterials::Label.new(orders)
    array = [:hello, :goodbye, 'Hello there']

    @label.row(array)

    assert_equal array, @label.row_maps[:object],
                "Passing array to Label#row does not work"
  end

  def test_row_hash
    @label = ShippingMaterials::Label.new(orders, headers: true)
    hash = { :order_id => :id,
             :name     => :name,
             :static_field => 'A string' }

    @label.row(hash)

    assert_equal %w(order_id name static_field), @label.headers,
                "Label headers are not being set properly"
    assert_equal hash.values, @label.row_maps[:object],
                "Label row map values not being properly set"
  end

  def test_row_hash_with_array
    @label = ShippingMaterials::Label.new(orders)
    hash = { :line_items => [:hello, :goodbye, 'Hello there'] }

    @label.row(hash)

    assert_equal hash[:line_items], @label.row_maps[:line_items],
                "Label row map not being set properly when given " \
                "hash with array"
  end

  def test_row_hash_with_hash
    @label = ShippingMaterials::Label.new(orders, headers: true)
    hash = {
      :line_items => {
        :order_id => :id,
        :name     => :name,
        :static_field => 'A string'
      }
    }

    @label.row(hash)

    assert_equal %w(order_id name static_field), @label.headers,
                "Label headers should be strings"
    assert_equal hash[:line_items].values, @label.row_maps[:line_items],
                "Label values should match line_item values"
   
  end

  def test_row_multi_call
    @label = ShippingMaterials::Label.new(orders, headers: true)
    hash1 = {
      :order_id => :id,
      :name     => :name,
      :static_fields => 'A string'
    }

    hash2 = {
      :line_items => {
        :id   => :id,
        :name => :name,
        :quantity => 2
      }
    }

    @label.row(hash1)
    @label.row(hash2)

    assert_equal %w(order_id name static_fields), @label.headers,
                "Headers should not be overwritten by secondary call to row"
  end

  def test_to_csv
    @label = ShippingMaterials::Label.new orders.select {|o| o.id == 1 },
                                          headers: true
    @label.row :order_id => :id,
               :name     => :name,
               :static_fields => 'A string'

    @label.row :line_items => [:id, :name, :quantity]

output = %Q|
order_id,name,static_fields
1,Andrew,A string
1,Plague Soundscapes,3
2,Surfer Rosa,1
|
    assert_equal output.strip, @label.to_csv.strip,
                "Label not properly converting to CSV"
  end
end