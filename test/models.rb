module TestModels
  class Order
    attr_accessor :id, :date, :name, :address, :email, :phone, :country,
                  :shipping_method, :line_items

    def initialize
      @line_items = []
    end
  end

  class LineItem
    attr_accessor :id, :name, :quantity, :price, :type
  end
end
