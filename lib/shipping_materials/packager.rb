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
        basename = group.basename
        sort_group(group)
        group.packing_slips.each {|ps| FileUtils.write_pdf(ps.to_s, basename) } 
        group.labels.each {|l| FileUtils.write_asset(l.to_s, basename) }
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
