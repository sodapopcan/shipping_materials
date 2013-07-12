module ShippingMaterials
  class Label
    require 'csv'

    attr_accessor :context

    def initialize(objects, options={})
      @objects = objects
      @rows = []
      @row_maps = {}
      @options = options
    end

    def row(hash)
      if hash.first.is_a? Hash
        @context = hash.keys.first
        @row_maps[@context] = hash[@context]
      else
        @row_maps[:object] = hash
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
      @row_maps.first[1].keys.map {|k| k.to_s } if @row_maps
    end

    def headers?
      @options[:headers]
    end
  end
end
