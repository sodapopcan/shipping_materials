require File.expand_path('../models', __FILE__)

module TestData

  def orders
    @orders ||= get_orders
  end

  def get_orders
    orders = []

    o = TestModels::Order.new
    o.id      = 1
    o.name    = 'Andrew'
    o.address = '207 Lawrence Ave E'
    o.email   = 'andrew@gelaskins.com'
    o.phone   = '416-555-0634'
    o.country = 'CA'
    o.shipping_method = 'UPS'

    li = TestModels::LineItem.new
    li.id       = 1
    li.name     = 'Plague Soundscapes'
    li.type     = 'Vinyl'
    li.quantity = 3
    li.price    = 15.95
    o.line_items << li

    li = TestModels::LineItem.new
    li.id       = 2
    li.name     = 'Surfer Rosa'
    li.type     = 'Vinyl'
    li.quantity = 1
    li.price    = 37.24
    o.line_items << li

    orders << o


    o = TestModels::Order.new
    o.id      = 2
    o.name    = 'Julie'
    o.address = '17 Whatever St'
    o.email   = 'julie@email.com'
    o.phone   = '232-555-0001'
    o.country = 'US'
    o.shipping_method = 'std'

    li = TestModels::LineItem.new
    li.id = 3
    li.name = 'Analphabetapolothology'
    li.type = 'Vinyl'
    li.quantity = 1
    li.price = 20.45
    o.line_items << li

    orders << o


    o = TestModels::Order.new
    o.id      = 3
    o.name    = 'Derek'
    o.address = '17 Whatever St'
    o.email   = 'derek@email.com'
    o.phone   = '232-555-0001'
    o.country = 'US'
    o.shipping_method = 'std'

    li = TestModels::LineItem.new
    li.id       = 4
    li.name     = 'The Immaculate Collection'
    li.type     = 'Vinyl'
    li.quantity = 1
    li.price    = 20
    o.line_items << li

    orders << o


    o = TestModels::Order.new
    o.id      = 4
    o.name    = 'Riley'
    o.address = '17 Whatever St'
    o.email   = 'riley@email.com'
    o.phone   = '416-555-0987'
    o.country = 'CA'
    o.shipping_method = 'UPSexp'

    li = TestModels::LineItem.new
    li.id       = 5
    li.name     = 'Don Caballero 2'
    li.type     = 'CD'
    li.quantity = 1
    li.price    = 12
    o.line_items << li

    orders << o


    o = TestModels::Order.new
    o.id      = 4
    o.name    = 'Miller'
    o.address = '17 Whatever St'
    o.email   = 'miller@email.com'
    o.phone   = '416-555-0987'
    o.country = 'CA'
    o.shipping_method = 'UPSexp'

    li = TestModels::LineItem.new
    li.id       = 6
    li.name     = 'Confield'
    li.type     = 'CD'
    li.quantity = 1
    li.price    = 12
    o.line_items << li

    orders << o


    o = TestModels::Order.new
    o.id      = 5
    o.name    = 'Jan'
    o.address = '45 Bergen Strasse'
    o.email   = 'jan@email.com'
    o.phone   = '876-555-0987'
    o.country = 'DE'
    o.shipping_method = 'UPSexp'

    li = TestModels::LineItem.new
    li.id       = 7
    li.name     = 'Living with the Ancients'
    li.type     = 'Vinyl'
    li.quantity = 1
    li.price    = 12
    o.line_items << li

    orders << o


    o = TestModels::Order.new
    o.id      = 6
    o.name    = 'J.M.'
    o.address = '1233 St. Clair Ave W'
    o.email   = 'jm@email.com'
    o.phone   = '876-555-0987'
    o.country = 'CA'
    o.shipping_method = 'std'

    li = TestModels::LineItem.new
    li.id       = 8
    li.name     = 'Vistavision'
    li.type     = 'Vinyl'
    li.quantity = 5
    li.price    = 12
    o.line_items << li

    orders << o
  end
end