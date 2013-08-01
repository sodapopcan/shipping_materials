require 'tilt'
require 'mustache'

require 'shipping_materials/version'
require 'shipping_materials/mixins/sortable'

require 'shipping_materials/config'
require 'shipping_materials/storage'
require 'shipping_materials/packager'
require 'shipping_materials/group'
require 'shipping_materials/csv_dsl'
require 'shipping_materials/packing_slips'
require 'shipping_materials/sorter'
require 'shipping_materials/s3'

module ShippingMaterials
  def self.config
    yield Config
  end
end
