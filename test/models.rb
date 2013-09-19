module TestModels
  class Order
    attr_accessor :id, :date, :name, :address, :email, :phone, :country,
                  :shipping_method, :line_items

    def initialize
      @line_items = []
    end
  end

  class LineItem
    attr_accessor :id, :name, :quantity, :price, :type, :variant

    def total
      quantity * price
    end
  end

  class Variant
    attr_accessor :name

    def initialize(hash)
      hash.each {|k,v| send("#{k}=", v) }
    end
  end

end
