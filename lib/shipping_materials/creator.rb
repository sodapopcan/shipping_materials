module ShippingMaterials
  class Creator
    def initialize(materials)
      @materials = materials
      materials.groups.each do |group|
        group.orders.each do |order|
          order.line_items.each do |li|
          end
        end
      end
    end
  end
end