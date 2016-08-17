# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dayman/version'

Gem::Specification.new do |spec|
  spec.name          = 'dayman'
  spec.version       = Dayman::VERSION
  spec.authors       = ['Kevin Bongart']
  spec.email         = ['contact@kevinbongart.net']

  spec.summary       = 'A JSON API Ruby client'
  spec.homepage      = "https://github.com/KevinBongart/dayman"
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
