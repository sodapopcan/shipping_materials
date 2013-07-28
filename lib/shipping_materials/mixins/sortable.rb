module ShippingMaterials
  module Sortable
    attr_accessor :sorters

    # DSL method
    def sort(context=:objects, &block)
      @sorters ||= {}
      @sorters[context] = Sorter.new
      @sorters[context].instance_eval(&block)
    end

    # Perform the sort
    def sort!
      @sorters.each do |context, sorter|
        @objects = if context == :objects
          sorter.sort(@objects)
        else
          @objects.each do |object|
            object.send(:"#{context}=", sorter.sort(object.send(context)))
          end
        end
      end
      @objects
    end
  end
end