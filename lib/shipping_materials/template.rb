module ShippingMaterials
  require 'mustache'

  class Template < Mustache
    def object=(object)
      object.public_methods(false).grep(/[^=]$/).each do |m|
        self.class.send(:define_method, m) do
          object.send(m)
        end
      end
    end
  end
end
