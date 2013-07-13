module ShippingMaterials
  class Sorter
    def initialize
      @rules = []
    end

    def rule(&block)
      @rules << block
    end

    def sort(items, i = 0)
      return items if !@rules[i] || items.size < 2

      a, b = [], []

      items.each do |item|
        if item.instance_eval(&@rules[i])
          a << item
        else
          b << item
        end
      end

      i += 1
      ( sort(a, i) + sort(b, i) ).compact
    end
  end
end