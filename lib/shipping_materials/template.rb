module ShippingMaterials
  require 'mustache'

  class Template < Mustache
    attr_reader :header, :footer

    def initialize(objects, filename)
      @objects  = objects
      @filename = filename
      @rendered = ''
			@header =''
			@footer = ''
    end

    def layout_file=(name)
      layout = File.read("#{template_path}/#{name}")
      @header, @footer = layout.split(/{{yield}}/)
    end

    def render!
			@rendered += @header

      @objects.each do |o|
        add_methods(o)
        @rendered << render
      end

			@rendered += @footer
    end

    def object=(object)
      add_methods(object)
    end

    def to_s
      @rendered
    end

    def to_pdf
			base = "#{Config.save_path}/#{File.basename(@filename)}"
			html, pdf = base + '.html', base + '.pdf'
      File.open(html, 'w') {|f| f.write(@rendered) }
      %x( wkhtmltopdf #{html} #{pdf} )
    end


    private

    def add_methods(object)
      @public_methods ||= object.public_methods(false).grep(/[^=]$/)
      @public_methods.each do |meth|
        self.class.send(:define_method, meth) do
          object.send(meth)
        end
      end
    end
  end
end
