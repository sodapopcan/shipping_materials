# Shipping Materials

Shipping Materials provides a simple DSL for grouping and sorting a collection
of orders and their items and creating print materials for them.  So far this
includes packing slips and CSVs for label makers.

## Warning

I would not designate this gem "production ready".  I will be using it in
production at my place of work very soon; I just wanted to get it out there.

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
      config.s3_bucket = 'bucket.domain.com'
      config.s3_access_key_id = ENV['AWS_ACCESS_KEY']
      config.s3_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    end
```

Note: The access key lines are most likely not needed if you are using the
proper environment variables, you just need to specify a bucket.

### The Packager

The DSL is provided via the ShippingMaterials::Packager class.

```ruby
  packager = ShippingMaterials::Packager.new
```

The Packager's `#package` method takes a collection of objects of the same
type.

```ruby
    orders = Order.where(state: 'placed')

    packager.package :orders do
      # ...
    end
```

Because we are creating shipping materials here, at the very least, it is
assumed you are going to want packing slips.  You may specify a global template
with the `#pdf` method:

```ruby
    packager.package orders do
      pdf 'path/to/template.mustache'
    end
```

Now, at the simplest level, we can start breaking these objects down into
groups.

```ruby
    packager.package orders do
      pdf 'path/to/template.mustache'

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

### Templating Right now, templating is done with Mustache.  I plan on adding
more in the future (or feel to send me a pull request).  Here is an example
template:

```html
    <html>
      {{# orders }}
        <div>
          <p>{{ number }}</p>
          {{# line_items }}
            <p>{{ name }}: ${{ price }} x {{ quantity }} = {{ total }}</p>
          {{/ line_items }}
        </div>
      {{/ orders }}
    </html>
```


The `orders` variable is inferred from the the class name of your objects.

Each group will yield one PDF file for print-out.

### CSV (for shipping labels)

Any label printer I know -- as well as things like UPS worldship -- use CSVs,
so Shipping Materials provides a little CSV templating DSL.  This is provided
via the `#csv` method and would generally be called inside a group block since
label requirements tend to differ across shipping methods.

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
            
        row line_items: [ 'H', :id, :name, :quantity, :price ] }
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
      pdf 'path/to/template.mustache'
        
      sort do
        # put orders containing only Vinyl at the top
        rule {
          return false if line_items.detect {|li| type != 'Vinyl' }
          return true  if line_items.detect {|li| type == 'Vinyl' }
        }
        
        # next come orders that have both Vinyl and CDs (and possibly # other)
        rule {
          line_items.select { |li|
            %w( Vinyl CD ).include?(li.type)
          }.uniq.size == 2
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

### Documentation

For more, see the docs... only there are no docs yet, hence the long README.

## Contributing

This is my first foray into the world of library authoring.  I welcome any and
all advice and pull requests with open arms, but for the love of whoever or
whatever you believe in: please follow [these
guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
when writing your commit messages.

## Contributing

For the love of God, please follow [these
guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
when writing your commit messages.
