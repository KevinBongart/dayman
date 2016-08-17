# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dayman'
require 'webmock/rspec'

class TestResource < Dayman::Resource
  self.site = 'http://dayman.com/'
end

class Thing < Dayman::Resource
end
