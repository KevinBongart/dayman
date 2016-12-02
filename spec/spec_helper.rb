# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dayman'
require 'pry'
require 'webmock/rspec'

class TestResource < Dayman::Resource
  self.site = 'http://dayman.com/'

  has_one :author
  has_many :publications
end

class Book < Dayman::Resource
end

class Magazine < Dayman::Resource
end

class Person < Dayman::Resource
end

class Thing < Dayman::Resource
end

module Foo
  module Bar
    class NamespacedResource < Dayman::Resource
    end
  end
end
