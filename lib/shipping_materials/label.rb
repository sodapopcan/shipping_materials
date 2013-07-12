module ShippingMaterials
  class Label
    require 'csv'

    attr_accessor :context

    def initialize(objects, options={})
      @objects = objects
      @rows = []
      @options = options
    end

    def row(hash)
      if hash.first.is_a? Hash
        @context = hash.keys.first
        @row_map = hash[@context]
      else
        @row_map = hash
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << headers if headers?
        csv.concat(@rows)
      end
    end

    def save(path)
    end

    def extension
      @options[:extension]
    end

    def headers
      @row_map.keys if @row_map
    end

    def headers?
      @options[:headers]
    end
  end
end
