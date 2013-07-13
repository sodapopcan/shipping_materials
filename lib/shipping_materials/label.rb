module ShippingMaterials
  class Label
    require 'csv'

    attr_accessor :row_maps, :headers

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
          @headers ||= hash_or_array.first[1].keys.map {|h| h.to_s }
          @row_maps[hash_or_array.first[0]] = hash_or_array.first[1].values
        else
          @headers ||= hash_or_array.keys.map {|h| h.to_s }
          @row_maps[:object] = hash_or_array.values
        end
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << headers if headers?
        contexts = @row_maps.keys
        @objects.each do |object|
          @row_maps.each do |context, row|
            if context == :object
              row.map do |o|
                object.send(o) if o.is_a? Symbol
                o if o.is_a? String
              end
            end

          end
        end
        csv.concat
      end
    end

    def save(path)
    end

    def extension
      @options[:extension]
    end

    def headers?
      @options[:headers]
    end
  end
end
