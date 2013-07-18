module ShippingMaterials
  class Group
    include Sortable

    attr_accessor :objects, :basename

    def initialize(basename, objects)
      @basename  = basename
      @objects   = objects
      @labels    = []
      @extension = 'csv'
      @headers   = false
    end

    def filter(&block)
      @objects = @objects.select {|o| o.instance_eval(&block) }
    end

    def labels(options={}, &block)
      if block
        label = Label.new(@objects, options)
        label.instance_eval(&block)
        @labels << label
      else
        @labels
      end
    end
  end
end
