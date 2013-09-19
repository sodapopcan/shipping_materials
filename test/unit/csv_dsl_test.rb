require 'test_helper'

module ShippingMaterials
  class CSVDSLTest < TestCase
    def test_row_array
      @csv = ShippingMaterials::CSVDSL.new(orders)
      array = [:hello, :goodbye, 'Hello there']

      @csv.row(array)

      assert_equal array, @csv.row_maps[:object][:values],
                  "Passing array to CSVDSL#row does not work"
    end

    def test_row_hash
      @csv = ShippingMaterials::CSVDSL.new(orders, headers: true)
      hash = { :order_id => :id,
               :name     => :name,
               :static_field => 'A string' }

      @csv.row(hash)

      assert_equal %w(order_id name static_field), @csv.headers,
                  "CSVDSL headers are not being set properly"
      assert_equal hash.values, @csv.row_maps[:object][:values],
                  "CSVDSL row map values not being properly set"
    end

    def test_row_hash_with_array
      @csv = CSVDSL.new(orders)
      hash = { :line_items => [:hello, :goodbye, 'Hello there'] }

      @csv.row(hash)

      assert_equal hash[:line_items], @csv.row_maps[:line_items][:values],
                  "CSVDSL row map not being set properly when given " \
                  "hash with array"
    end

    def test_row_hash_with_hash
      @csv = CSVDSL.new(orders, headers: true)
      hash = {
        :line_items => {
          :order_id => :id,
          :name     => :name,
          :static_field => 'A string'
        }
      }

      @csv.row(hash)

      assert_equal %w(order_id name static_field), @csv.headers,
                  "CSVDSL headers should be strings"
      assert_equal hash[:line_items].values, @csv.row_maps[:line_items][:values],
                  "CSVDSL values should match line_item values"
    
    end

    def test_row_multi_call
      @csv = CSVDSL.new(orders, headers: true)
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

      @csv.row(hash1)
      @csv.row(hash2)

      assert_equal %w(order_id name static_fields), @csv.headers,
                  "Headers should not be overwritten by secondary call to row"
    end

    def test_array_chain
      @csv = CSVDSL.new(orders.select {|o| o.name == 'Andrew' })
      hash = {
        :line_items => {
          :order_id => :id,
          :name => :name,
          :variant_name => [ :variant, :name ]
        }
      }

      @csv.row(hash)

      assert_equal "1,Plague Soundscapes,plague soundscapes\n" \
                  "2,Surfer Rosa,surfer rosa\n",
                  @csv.to_csv,
                  "CSV method chaining is borked"
    end

    def test_proc
      @csv = CSVDSL.new(orders.select {|o| o.name == 'Andrew' })
      @csv.row [ proc { "#{id}+#{name}" } ]

      assert_equal "1+Andrew\n", @csv.to_csv, "CSV with proc doesn't work"
    end

    def test_callbacks
      @csv = CSVDSL.new(orders.select {|o| o.id == 1 })
      @csv.row :order_id      => :id,
               :name          => :name,
               :static_fields => 'A string'
      @csv.row({ :line_items => [:id, :name, :quantity] }, :if => proc {|o| o.line_items.size < 1 })
      
      assert_equal "1,Andrew,A string\n", @csv.to_csv
    end

    def test_to_csv
      @csv = CSVDSL.new(orders.select {|o| o.id == 1 }, headers: true)
      @csv.row :order_id       => :id,
               :name          => :name,
               :static_fields => 'A string'

      @csv.row :line_items => [:id, :name, :quantity]

      output = "order_id,name,static_fields\n" \
              "1,Andrew,A string\n" \
              "1,Plague Soundscapes,3\n" \
              "2,Surfer Rosa,1"

      assert_equal output.strip, @csv.to_csv.strip,
                  "CSVDSL not properly converting to CSV"
    end
  end
end