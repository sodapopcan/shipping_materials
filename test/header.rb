require 'test/unit'
require 'debugger'

require File.expand_path('../data.rb', __FILE__)

Dir.glob('lib/shipping_materials/*.rb').each do |file|
  require File.expand_path("../../#{file}", __FILE__)
end

class UnitTest < Test::Unit::TestCase
  include TestData
end
