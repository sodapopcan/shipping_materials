ShippingMaterials.config do |config|
  config.save_path = MyProject::Config[:asset_storage_location]
end

packager = ShippingMaterials::Packager.new

orders = Orders.where(state: 'placed')

packager.package orders do
  pdf 'path/to/template',

  sort(:line_items) {
    rule { type == 'Vinyl' }
    rule { type == 'CD' }
    rule { type == 'Cassette' }
  }

  sort {
    rule { line_items.detect {|li| li.type == 'vinyl' } }
  }

  group 'canada_standard_shipping' do
    filter { country == 'CA' && shipping_method == 'std' }

    csv(extenstion: 'txt', headers: true) {
      row code:     'Q',
          order_id: :id,
          hello:    :hello

      row line_items: [ 'H', :id, :name, :price, :quantity ]
    }
  end
end