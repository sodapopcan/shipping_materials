module ShippingMaterials
  class PackingSlips
    def initialize(objects, template_file)
      @objects  = objects
      @template_file = template_file
    end

    def to_s
      t = Mustache.new
      t.template_file = @template_file
      t[Config.base_context] = @objects
      t.render
    end

    alias_method :to_html, :to_s
  end
end