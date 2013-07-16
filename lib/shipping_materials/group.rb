module ShippingMaterials
  class Group
    attr_accessor :objects, :filename

    def initialize(filename, objects)
      @filename  = filename
      @objects   = objects
      @labels    = []
      @extension = 'csv'
      @headers   = false
    end

    def filter(&block)
      @objects = @objects.select {|o| o.instance_eval(&block) }
    end

    def labels(options={}, &block)
      if options.any?
        label = Label.new(@objects, options)
        label.instance_eval(&block) if block

        @labels << label
      else
        @labels
      end
    end
  end
end
