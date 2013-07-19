require 'shipping_materials/version'
require 'shipping_materials/mixins/sortable'

require 'shipping_materials/config'
require 'shipping_materials/file_utils'
require 'shipping_materials/packager'
require 'shipping_materials/group'
require 'shipping_materials/label'
require 'shipping_materials/packing_slips'
require 'shipping_materials/sorter'

module ShippingMaterials
  def self.config
    yield Config
  end
end
