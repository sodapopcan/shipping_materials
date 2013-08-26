module ShippingMaterials
  class Sorter
    def initialize
      @rules = []
      @attr_callbacks = []
    end

    def rule(&block)
      @rules << block
    end

    # This is suiting MY purpose for now
    # The plan is to implement chainable callbacks
    def each_by(attr)
      @attr_callbacks << attr
    end

    def sort(items, i=0)
      return items if !@rules[i] || items.size < 2

      a, b = [], []

      items.each do |item|
        if item.instance_eval(&@rules[i])
          a << item
        else
          b << item
        end
      end

      apply_callbacks(a)
      apply_callbacks(b)

      i += 1
      ( sort(a, i) + sort(b, i) ).compact
    end


    private

    def apply_callbacks(items)
      @attr_callbacks.each do |attr|
        items.sort! do |a,b|
          b.send(attr) <=> a.send(attr)
        end
      end
    end
  end
end