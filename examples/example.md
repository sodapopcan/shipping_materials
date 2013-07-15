# Examples

Note: examples are in ruby 1.9 syntax because I prefer it.  This library is compatible
back to 1.8.

  packager = ShippingMaterials::Packager.new

  orders = Orders.where(state: 'placed')

  packager.package orders do
    packing_slips pdf: 'path/to/template'

    group 'canada_standard_shipping' do
      filter { country == 'CA' && shipping_method == 'std' }
    end
  end