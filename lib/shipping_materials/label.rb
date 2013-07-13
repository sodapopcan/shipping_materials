module ShippingMaterials
  class Label
    require 'csv'

    attr_accessor :objects, :row_maps

    def initialize(objects, options={})
      @objects = objects
      @rows = []
      @row_maps = {}
      @options = options
    end

    # This method is on the complex side. It is a DSL method that performs
    # type-checking and also sets the headers.
    def row(hash_or_array)
      if hash_or_array.is_a? Array
        @row_maps[:object] = hash_or_array
      elsif hash_or_array.is_a? Hash
        if hash_or_array.first[1].is_a? Array
          @row_maps[hash_or_array.first[0]] = hash_or_array.first[1]
        elsif hash_or_array.first[1].is_a? Hash
          self.headers = hash_or_array.first[1]
          @row_maps[hash_or_array.first[0]] = hash_or_array.first[1].values
        else
          self.headers = hash_or_array
          @row_maps[:object] = hash_or_array.values
        end
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << headers if headers?
        @objects.each do |object|
          @row_maps.each do |context, methods|
            if context == :object
              csv << get_row(object, methods)
            else
              object.send(context).each do |c|
                csv << get_row(c, methods)
              end
            end
          end
        end
      end
    end

    def save(path)
    end

    def extension
      @options[:extension]
    end

		def headers
			@headers
		end

		def headers=(object)
			@headers ||= object.keys.map {|h| h.to_s } if self.headers?
		end

    def headers?
      @options[:headers]
    end

    private

    def get_row(object, methods)
      methods.map do |meth|
        if meth.is_a? Symbol
          object.send(meth)
        elsif meth.is_a? String
          meth
        end
      end
    end

  end
end
