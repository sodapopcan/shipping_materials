module ShippingMaterial
  class Sorter
    def initialize(orders)
      @orders = orders
      @rules = []
    end

    def sort_rules(&block)
      instance_eval(&block)
    end

    def sort(items, i = 0)
      return items unless @rules[i]
      return items if items.size < 2
      a, b = [], []
      items.each do |item|
        if item.instance_eval(&@rules[i])
          a << item
        else
          b << item
        end
      end
      i += 1
      items = sort(a, i) + sort(b, i)
      items.compact!
    end

    protected

    def rule(&block)
      @rules << block
    end
  end
end