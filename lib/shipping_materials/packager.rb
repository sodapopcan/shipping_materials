module ShippingMaterials
  class Packager
		include Sortable

    attr_accessor :objects, :groups, :template

		def initialize
      @groups = []
		end

    def package(objects, &block)
      @objects = objects
      instance_eval(&block)
			@groups.each do |group|
        sort_group(group)
        create_packing_slips(group)
        csvs(group)
			end
      Storage.gzip if Config.use_gzip?
    end

    def pdf(template)
      @packing_slip_template = template
		end

    def group(basename, &block)
      group = Group.new(basename, @objects)
      group.instance_eval(&block) if block
      @groups << group
    end

    private

    def sort_group(group)
      return unless self.sorters.nil?
      group.sorters ||= self.sorters unless group.sorters.nil?
      group.sort!
    end

    def create_packing_slips(group)
      packing_slip = PackingSlips.new(group.objects, @packing_slip_template)
      Storage.write_pdf(group.basename, packing_slip.to_s)
    end

    def csvs(group)
      group.csvs.each do |csv|
        extension = group.basename + '.' + csv.extension
        Storage.write_file(extension, csv.to_s)
      end
    end
  end
end
