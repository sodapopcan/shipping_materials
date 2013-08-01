module ShippingMaterials
  class PackingSlips
    def initialize(objects, template_file)
      @objects       = objects
      @template_file = template_file
    end

    def to_s
			if File.extname(@template_file) == '.mustache'
				t = Mustache.new
				t.template_file = @template_file
				t[Config.base_context] = @objects
				t.render
			else
				t = Tilt.new(@template_file)
				t.render(@objects)
			end
    end

    alias_method :to_html, :to_s
  end
end