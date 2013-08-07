module ShippingMaterials
  class CSVDSL
    require 'csv'

    attr_accessor :objects, :row_maps

    attr_reader :headers

    def initialize(objects, options={})
      @objects           = objects
      @row_maps          = {}
      @row_map_callbacks = {}
      @options           = options
    end

    # This method is on the complex side. It is a DSL method that
    # performs type-checking and also sets the headers.
    # Be sure to see headers=() defined below
    def row(collection)
      if collection.is_a? Array
        @row_maps[:object] = collection
      elsif collection.is_a? Hash
        f = collection.first
        if f[1].is_a? Array
          @row_maps[f[0]] = f[1]
        elsif f[1].is_a? Hash
          self.headers = collection.first[1]
          @row_maps[f[0]] = f[1].values
        else
          self.headers = collection
          @row_maps[:object] = collection.values
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

    alias_method :to_s, :to_csv

    def extension
      @options[:extension] || 'csv'
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
        elsif meth.is_a? Array
          meth.reduce(object) {|obj, m| obj.send(m) }
        elsif meth.is_a? Proc
          object.instance_eval(&meth)
        elsif meth.is_a? String
          meth
        end
      end
    end
  end
end
