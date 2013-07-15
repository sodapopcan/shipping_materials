packager = ShippingMaterials::Packager.new

orders = Orders.where(state: 'placed')

packager.package orders do
  pdf template: 'path/to/template',
      layout:   'path/to/layout'

  sort(:line_items) {
    rule { type == 'Vinyl' }

    after_each_by_attr(:quantity)
  }

  sort {
    rule { line_items.detect {|li| li.type == 'vinyl' } }
  }

  group 'canada_standard_shipping' do
    filter { country == 'CA' && shipping_method == 'std' }

    csv(headers: true) {
      row code:     :'Q',
          order_id: :id,
          hello:    :hello

      row line_items: [ 'H', :id, :name, :price, :quantity ]
    }

    sort {

    }
  end
end