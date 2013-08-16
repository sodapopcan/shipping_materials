# Shipping Materials

Shipping Materials provides a simple DSL for grouping and sorting a collection
of orders and their items and creating print materials for them.  So far this
includes packing slips and CSVs for label makers.

## Installation

    $ gem install shipping_materials

## Dependencies

`wkhtmltopdf` if used for PDF generation.  The call to it is made as a linux
command therefore this plugin will not work on Windows yet.
    
`gzip` is used for the zip functionality.

## Usage

### Setup

There is a little bit of configuration you are going to want to do first and
that is to add a save_path.

```ruby
  ShippingMaterials.config do |config|
    config.save_path = 'local/save/path'
  end
```

If you would like to use S3, add the following:

```ruby
  ShippingMaterials.config do |config|
    config.s3_bucket            = 'bucket.domain.com'
    config.s3_access_key_id     = ENV['AWS_ACCESS_KEY']
    config.s3_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  end
```

### The Packager

The DSL is provided via the `ShippingMaterials::Packager` class.

```ruby
  packager = ShippingMaterials::Packager.new
```

The Packager's `#package` method takes a collection of objects of the same
type.

```ruby
  orders = Order.where(state: 'placed')

  packager.package orders do
    # ...
  end
```

Because we are creating shipping materials here, at the very least, it is
assumed you are going to want packing slips.  You may specify a global template
with the `#pdf` method:

```ruby
  packager.package orders do
    pdf 'path/to/template.erb'
  end
```

Now, at the simplest level, we can start breaking these objects down into
groups.

```ruby
  packager.package orders do
    pdf 'path/to/template.erb'

    group 'Canadian Standard Post' do
      filter {
        ship_method == 'std' && country == 'CA'
      }
    end
    
    group 'United States UPS Expedited' do
      filter {
        ship_method == 'UPSexp' && country == 'US'
      }
    end
    
    group 'International World Ship' do
      filter {
        ship_method == 'UPS' && !%w[ US CA ].include?(country)
      }
    end
  end
```

PDFs (one per group) will now be created.  With groups named as above, you can
expect the file names 'CanadianStandardPost.pdf', 'UnitedStatesUPSExpedite.pdf'
and 'InternationalWorldShip.pdf'.

### Templating

Shipping Materials uses [Tilt](http://www.github.com/rtomayko/tilt) therefore
there are a number of options available.  Templates are evaluated within the
context of the order array. A sample ERB template would look like this:

```erb
  <html>
    <body>
      <% self.each do |order| %>
        <p><%= order.number %>
        <div>
        <% order.line_items.each do |li| %>
          <p><%= li.desc %>: $<%= li.price %> x <%= li.qty %> = <%= li.total %></p>
        <% end %>
        </div>
      <% end %>
    </body>
  </html>
```

Each group will produce one PDF.

### CSV (for shipping labels)

Any label printer I know -- as well as things like UPS Worldship -- use CSVs,
so Shipping Materials provides a little CSV templating DSL.  This is provided
via the `Group#csv` method.

The `#csv` method takes a block which exposes the `#row` method.  `#row` takes
a hash or an array and may be called multiple times.

Here is an example with hashes:

```ruby
  group 'Canadian Standard Post' do
    csv(headers: true) {
      row 'Code' => 'Q',
          'Order Number' => :number,
          'Name'     => [ :shipping_address, :name ]
           # ...
          'Country'  => [ :shipping_address, :country, :iso ]
          
      row line_items: [ 'H', :id, :name, :quantity, :price ]
    }
  end
```

In this example, the first call to row is evaluated in the context of each
order.  Symbols are called as methods whereas string values are kept as-is.  In
order to chain method calls, use an array of symbols as a value.  For example,
`[ :shipping_address, :country, :iso ]` will call
`order.shipping_method.country.iso`.

Passing `headers: true` to the csv method will use the keys from the _first_
call to row (if it is a hash) as the headers for the CSV.

As demonstrated in the second call to row, you can evalute your row in the
context of your line items (or other one-to-many relationship) using its method
name as a key.

### Sorting

While most sorting should probably be done at the query level, Shipping
Materials provides a sorting DSL for more complex sorts.  For example:

```ruby
  packager.package orders do
    pdf 'path/to/template.erb'
      
    sort do
      # put orders containing only Vinyl at the top
      rule {
        line_items.select {|li| type != 'Vinyl' }.any?
      }
      
      # next come orders that have both Vinyl and CDs and nothing else
      rule {
        line_items.select {|li| %w[ Vinyl CD ].include?(li.type) }.uniq.size == 2
      }
      
      # get the picture?
    end
      
    group # ...
  end
```

A merge sort will be performed sorting the orders within each group according
to each rule in the order they are defined.

While it is definitely recommended to sort line items at the query level, you
can operate in the context of line items by passing the name of the association
to the sort method (ie: your association doesn't have to be called "line_items"
specifically):

```ruby
  sort(:line_items) do
    rule { type == 'Vinyl' }
    rule { type == 'CD' }
    rule { type == 'Cassette' }
    rule { type == '8-Track' }
  end
```

This will sort your line items within each packing slip.

## Documentation

Other than this README, there is no documentation yet.  There are a few other
experimental and volatile features not mentioned here.  They are certainly
going to change soon.

## Contributing

This is my first foray into the world of library authoring.  I welcome any and
all advice and pull requests with open arms, but for the love of whoever or
whatever you believe in: please follow [these
guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
when writing your commit messages.

## A note about the tests

I am still learning to test properly.  Tests are passing _but_ some of them are
writing to the filesystem.  These wrongs will be righted in due time.
