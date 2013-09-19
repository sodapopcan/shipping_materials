module ShippingMaterials
  class PackingSlips
    def initialize(objects, template_file)
      @objects       = objects
      @template_file = template_file
    end

    def to_s
      t = Tilt.new(@template_file)
      t.render(@objects)
    end

    alias_method :to_html, :to_s
  end
end