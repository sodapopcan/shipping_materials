module ShippingMaterials
  class Group
    include Sortable

    attr_accessor :objects, :basename, :csvs

    def initialize(basename, objects)
      @basename  = basename
      @objects   = objects
      @csvs      = []
      @extension = 'csv'
      @headers   = false
    end

    def filter(&block)
      @objects = @objects.select {|o| o.instance_eval(&block) }
    end

    def csv(options={}, &block)
      if block
        csv = CSVDSL.new(@objects, options)
        csv.instance_eval(&block)
        @csvs << csv
      end
    end
  end
end
