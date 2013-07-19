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
        create_labels(group)
			end
    end

    def packing_slips(options={})
      @file_type, @template_location = options.first
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
      packing_slip = PackingSlips.new(group.objects, @template_location)
      FileUtils.write_pdf(group.basename, packing_slip.to_s)
    end

    def create_labels(group)
      group.labels.each do |label|
        extension = group.basename + '.' + label.extension
        FileUtils.write_file(extension, label.to_s)
      end
    end
  end
end
