module ShippingMaterials
  class Label
    require 'csv'

    attr_accessor :context, :row_maps, :headers

    def initialize(objects, options={})
      @objects = objects
      @rows = []
      @row_maps = {}
      @options = options
    end

    def row(hash)
      if hash.first.is_a? Hash
        @context = hash.keys.first
        @row_maps[@context] = hash[@context].values
        @headers = hash[@context].keys
      else
        @row_maps[:object] = hash.values
        @headers = hash.keys.map {|k| k.to_s } if @row_maps
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

    def headers?
      @options[:headers]
    end
  end
end
