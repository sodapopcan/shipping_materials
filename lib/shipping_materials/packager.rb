module ShippingMaterials
  class Packager
    attr_accessor :groups, :template

    def package(objects, &block)
      @objects = objects
      @groups = []
      instance_eval(&block)
    end

    def format(options={})
      if options.size > 0
        @format, @template = options.first
      else
        @format
      end
    end

    # def sort(objects=:objects, &block)

    #   @sorter ||= Sorter.new
    #   @sorter.rules << &block
    # end


    protected

    def group(filename, &block)
      group = Group.new(filename, @objects)
      group.instance_eval(&block) if block
      @groups << group
    end
  end
end
