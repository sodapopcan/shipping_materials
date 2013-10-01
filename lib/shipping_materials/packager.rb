module ShippingMaterials
  class Packager
    include Sortable

    attr_accessor :objects, :groups, :template

    def initialize
      @groups = []
      @sorters = {}
    end

    def package(objects, &block)
      @objects = objects
      instance_eval(&block)
      @groups.each do |group|
        sort_group(group)
        create_packing_slips(group)
        create_csvs(group)
      end
      if Config.use_gzip?
        Storage.write_gzip rescue nil
      end
      self
    end

    def html(template)
      @packing_slip_template = template
      @packing_slip_ext = :html
    end

    def pdf(template)
      @packing_slip_template = template
      @packing_slip_ext = :pdf
    end

    def group(basename, &block)
      group = Group.new(basename, @objects)
      group.instance_eval(&block) if block
      @groups << group
    end

    private
      def sort_group(group)
        group.sorters ||= self.sorters
        group.sort!
      end

      def create_packing_slips(group)
        packing_slip = PackingSlips.new(group.objects, @packing_slip_template)
        filename = "#{group.basename}.#{@packing_slip_ext}"
        Storage.send(:"write_#{@packing_slip_ext}", filename , packing_slip.to_s)
      end

      def create_csvs(group)
        group.csvs.each do |csv|
          filename = Storage.filenameize(group.basename) + '.' + csv.extension
          Storage.write_file(filename, csv.generate(group.objects))
      end
    end
  end
end
