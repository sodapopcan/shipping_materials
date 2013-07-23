# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipping_materials/version'

Gem::Specification.new do |spec|
  spec.name          = 'shipping_materials'
  spec.version       = ShippingMaterials::VERSION
  spec.authors       = ['Andrew Haust']
  spec.email         = ['andrewwhhaust@gmail.com']
  spec.description   = %q{DSL for creating packing slips
                          and general shipping materials}
  spec.summary       = %q{Shipping Materials}
  spec.homepage      = "http://www.github.com/sodapopcan/shipping_materials"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) {|f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mustache'
  spec.add_dependency 'aws-sdk'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'debugger'
end
