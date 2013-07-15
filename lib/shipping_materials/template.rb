module ShippingMaterials
  require 'mustache'

  attr_accessor :layout
	attr_reader :rendered

  class Template < Mustache
    def initialize(objects)
      @objects  = objects
      @rendered = ''
    end

    def package
      @objects.each do |o|
        add_methods(o)
        @rendered << render
      end
    end

    def object=(object)
      add_methods(object)
    end

		def to_s
			@rendered
		end


    private

    def add_methods(object)
			@public_methods ||= object.public_methods(false).grep(/[^=]$/)
      @public_methods.each do |m|
        self.class.send(:define_method, m) do
          object.send(m)
        end
      end
    end
  end
end
