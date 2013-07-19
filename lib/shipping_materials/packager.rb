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
				FileUtils.write_pdf(group.packing_slips)
				FileUtils.write_asset(group.labels)
			end
    end

    def packing_slips(file_type=nil, template=nil)
			@packing_slips ||= PackingSlips.new(file_type, template)
		end

    def group(filename, &block)
      group = Group.new(filename, @objects)
      group.instance_eval(&block) if block
      @groups << group
    end
  end
end
