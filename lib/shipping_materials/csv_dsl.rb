module ShippingMaterials
  class CSVDSL
    require 'csv'

    attr_accessor :objects, :row_maps
    attr_reader :headers

    def initialize(objects, options={})
      @objects   = objects
      @row_maps  = []
      @options   = options
    end

    # This method is on the complex side. It is a DSL method that
    # performs type-checking and also sets the headers.
    # Be sure to see headers=() defined below
    def row(collection, callbacks={})
      if collection.is_a? Array
        update_row_maps(:object, collection, callbacks)
      elsif collection.is_a? Hash
        f = collection.first
        if f[1].is_a? Array
          update_row_maps(f[0], f[1], callbacks)
        elsif f[1].is_a? Hash
          self.headers = f[1]
          update_row_maps(f[0], f[1].values, callbacks)
        else
          self.headers = collection
          update_row_maps(:object, collection.values, callbacks)
        end
      end
    end

    def to_csv
      CSV.generate do |csv|
        csv << headers if headers?
        @objects.each do |object|
          @row_maps.each do |row_map|
            next unless apply_callbacks(row_map[:callbacks], object)
            if row_map[:context] == :object
              csv << get_row(object, row_map[:values])
            else
              object.send(row_map[:context]).each do |obj|
                csv << get_row(obj, row_map[:values])
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
      def apply_callbacks(callbacks, object)
        return true unless callbacks.any?
        if callbacks[:if]
          callbacks[:if].call(object)
        else
          true
        end
      end

      def get_row(object, methods)
        methods.map do |meth|
          if meth.is_a? Symbol
            object.send(meth)
          elsif meth.is_a? Array
            meth.reduce(object) {|o,m| o.send(m) }
          elsif meth.is_a? Proc
            object.instance_eval(&meth)
          elsif meth.is_a? String
            meth
          end
        end
      end

      def update_row_maps(context, values, callbacks)
        @row_maps << {
          context: context,
          values: values,
          callbacks: callbacks
        }
      end
  end
end
